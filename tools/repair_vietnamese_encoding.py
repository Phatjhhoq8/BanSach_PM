import json
import re
import shutil
from datetime import datetime
from pathlib import Path

import ftfy


ROOT = Path(__file__).resolve().parents[1]
APP_DATA = ROOT / "Source" / "App_Data"
PRODUCT_JSON = APP_DATA / "product-details.json"


BAD_PATTERN = re.compile(r"[ÃÄÂ]|áº|á»|�")


def repair_text(value):
    if not isinstance(value, str) or not value:
        return value

    repaired = ftfy.fix_text(value)

    # ftfy repairs most Vietnamese mojibake. These currency/letter fragments are
    # common leftovers from Windows-1252 double-decoding of UTF-8 data.
    replacements = {
        "Ä'": "đ",
        "Ä‘": "đ",
        "Ä": "đ",
        "Ä�": "Đ",
        "Ä": "Đ",
        "Ã„â€˜": "đ",
        "Ã„Â‘": "đ",
        "Ã„Â": "Đ",
        "á»™": "ộ",
        "á»…": "ễ",
        "á»": "ề",
        "á»‡": "ệ",
        "á»‹": "ị",
        "á»": "ọ",
        "á»": "ỏ",
        "á»‘": "ố",
        "á»“": "ồ",
        "á»•": "ổ",
        "á»—": "ỗ",
        "á»˜": "Ộ",
        "á»¯": "ữ",
        "á»±": "ự",
        "á»©": "ứ",
        "á»«": "ừ",
        "á»­": "ử",
        "á»§": "ủ",
        "á»¥": "ụ",
        "á»³": "ỳ",
        "á»·": "ỷ",
        "á»¹": "ỹ",
        "á»µ": "ỵ",
        "á»…n": "ễn",
        "Â": "",
    }
    for bad, good in replacements.items():
        repaired = repaired.replace(bad, good)

    return repaired


def repair_value(value):
    if isinstance(value, str):
        return repair_text(value)
    if isinstance(value, list):
        return [repair_value(item) for item in value]
    if isinstance(value, dict):
        return {key: repair_value(item) for key, item in value.items()}
    return value


def merge_clean_backups(current):
    """Prefer known clean backups for products they contain."""
    clean_sources = [
        APP_DATA / "foreign-language-product-details.json",
        APP_DATA / "product-details.backup-20260424-233639.json",
        APP_DATA / "product-details.backup-20260424-233052.json",
    ]

    for source in clean_sources:
        if not source.exists():
            continue
        with source.open("r", encoding="utf-8") as handle:
            clean_data = json.load(handle)
        for slug, product in clean_data.items():
            current[slug] = product

    return current


def count_bad_strings(value):
    count = 0
    if isinstance(value, str):
        return 1 if BAD_PATTERN.search(value) else 0
    if isinstance(value, list):
        for item in value:
            count += count_bad_strings(item)
    elif isinstance(value, dict):
        for item in value.values():
            count += count_bad_strings(item)
    return count


def main():
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = PRODUCT_JSON.with_name(f"product-details.pre-encoding-fix-{timestamp}.json")
    shutil.copy2(PRODUCT_JSON, backup)

    with PRODUCT_JSON.open("r", encoding="utf-8") as handle:
        data = json.load(handle)

    before_bad = count_bad_strings(data)
    data = merge_clean_backups(data)
    data = repair_value(data)
    after_bad = count_bad_strings(data)

    with PRODUCT_JSON.open("w", encoding="utf-8") as handle:
        json.dump(data, handle, ensure_ascii=False, indent=2)
        handle.write("\n")

    sql_payload = APP_DATA / f"product-details.fixed-for-sql-{timestamp}.json"
    with sql_payload.open("w", encoding="utf-8") as handle:
        json.dump(data, handle, ensure_ascii=False)

    print(f"backup={backup}")
    print(f"sql_payload={sql_payload}")
    print(f"products={len(data)}")
    print(f"bad_strings_before={before_bad}")
    print(f"bad_strings_after={after_bad}")


if __name__ == "__main__":
    main()
