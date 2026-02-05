#!/usr/bin/env python3
from __future__ import annotations

import os
import boto3
from botocore.exceptions import ClientError


TARGET_REGION = os.getenv("AUDIT_REGION", "us-east-2")


def get_bucket_region(s3_client, bucket_name: str) -> str:
    resp = s3_client.get_bucket_location(Bucket=bucket_name)
    loc = resp.get("LocationConstraint")

    if loc is None:
        return "us-east-1"
    if loc == "EU":
        return "eu-west-1"
    return loc


def has_versioning_enabled(s3_client, bucket_name: str) -> bool:
    resp = s3_client.get_bucket_versioning(Bucket=bucket_name)
    return resp.get("Status") == "Enabled"


def has_default_encryption(s3_client, bucket_name: str) -> bool:
    try:
        s3_client.get_bucket_encryption(Bucket=bucket_name)
        return True
    except ClientError as e:
        code = e.response["Error"]["Code"]
        if code in (
            "ServerSideEncryptionConfigurationNotFoundError",
            "ServerSideEncryptionConfigurationNotFound",
        ):
            return False
        raise


def main() -> None:
    s3 = boto3.client("s3")

    print(f"\n=== Auditoria de Gobernanza S3 (Region: {TARGET_REGION}) ===\n")

    compliant: list[str] = []
    no_versioning: list[str] = []
    no_encryption: list[str] = []

    buckets = s3.list_buckets().get("Buckets", [])

    for b in buckets:
        name = b["Name"]

        if get_bucket_region(s3, name) != TARGET_REGION:
            continue

        versioning_ok = has_versioning_enabled(s3, name)
        encryption_ok = has_default_encryption(s3, name)

        if versioning_ok and encryption_ok:
            compliant.append(name)
        else:
            if not versioning_ok:
                no_versioning.append(name)
            if not encryption_ok:
                no_encryption.append(name)

    print(" Buckets que cumplen versionamiento y encriptacion:")
    if compliant:
        for n in compliant:
            print(f"  - {n}")
    else:
        print("  (ninguno)")

    print("\n Buckets sin versionamiento habilitado:")
    if no_versioning:
        for n in no_versioning:
            print(f"  - {n}")
    else:
        print("  (ninguno)")

    print("\n Buckets sin encriptacion por defecto:")
    if no_encryption:
        for n in no_encryption:
            print(f"  - {n}")
    else:
        print("  (ninguno)")


if __name__ == "__main__":
    main()
