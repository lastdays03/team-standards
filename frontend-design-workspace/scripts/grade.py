"""Automated grading script for frontend-design skill evaluation."""
import json
import re
import sys
from pathlib import Path


def grade_html(html_path: str) -> dict:
    """Grade an HTML file against the programmatic assertions."""
    path = Path(html_path)
    if not path.exists():
        return {"error": f"File not found: {html_path}", "results": []}

    content = path.read_text(encoding="utf-8")
    content_lower = content.lower()

    results = []

    # A1: CSS 변수 시스템 (5개 이상)
    css_vars = re.findall(r"--[\w-]+\s*:", content)
    unique_vars = set(v.strip().rstrip(":") for v in css_vars)
    a1_passed = len(unique_vars) >= 5
    results.append({
        "text": "A1: CSS 변수 시스템 사용 (5개 이상)",
        "passed": a1_passed,
        "evidence": f"Found {len(unique_vars)} unique CSS variables: {list(unique_vars)[:8]}..."
    })

    # A2: 제네릭 폰트 미사용 (Inter, Roboto, Arial이 font-family의 첫 번째가 아님)
    font_family_matches = re.findall(r"font-family\s*:\s*['\"]?([^;'\"]+)", content)
    generic_as_primary = False
    generic_fonts = ["inter", "roboto", "arial", "system-ui", "sans-serif"]
    for fm in font_family_matches:
        first_font = fm.split(",")[0].strip().strip("'\"").lower()
        if first_font in generic_fonts:
            generic_as_primary = True
            break
    # Also check --font-display and --font-body definitions
    font_var_matches = re.findall(r"--font-(?:display|body)\s*:\s*['\"]?([^;'\"]+)", content)
    for fm in font_var_matches:
        first_font = fm.split(",")[0].strip().strip("'\"").lower()
        if first_font in generic_fonts:
            generic_as_primary = True
            break
    a2_passed = not generic_as_primary
    results.append({
        "text": "A2: 제네릭 폰트 미사용",
        "passed": a2_passed,
        "evidence": f"Font families found: {font_family_matches[:5]}. Font vars: {font_var_matches[:3]}. Generic as primary: {generic_as_primary}"
    })

    # A3: Google Fonts 로딩
    a3_passed = "fonts.googleapis.com" in content
    results.append({
        "text": "A3: Google Fonts 로딩",
        "passed": a3_passed,
        "evidence": "Found fonts.googleapis.com link" if a3_passed else "No Google Fonts link found"
    })

    # A4: 애니메이션 존재
    has_keyframes = "@keyframes" in content_lower
    has_animation = bool(re.search(r"animation\s*:", content_lower))
    a4_passed = has_keyframes or has_animation
    keyframe_names = re.findall(r"@keyframes\s+([\w-]+)", content)
    results.append({
        "text": "A4: 애니메이션 존재",
        "passed": a4_passed,
        "evidence": f"@keyframes: {has_keyframes} (names: {keyframe_names[:5]}), animation prop: {has_animation}"
    })

    # A5: 반응형 대응
    has_media = "@media" in content_lower
    has_clamp = "clamp(" in content_lower
    a5_passed = has_media or has_clamp
    media_count = content_lower.count("@media")
    clamp_count = content_lower.count("clamp(")
    results.append({
        "text": "A5: 반응형 대응",
        "passed": a5_passed,
        "evidence": f"@media queries: {media_count}, clamp() uses: {clamp_count}"
    })

    # A7: 호버 인터랙션
    hover_count = content_lower.count(":hover")
    a7_passed = hover_count > 0
    results.append({
        "text": "A7: 호버 인터랙션",
        "passed": a7_passed,
        "evidence": f"Found {hover_count} :hover rules"
    })

    pass_count = sum(1 for r in results if r["passed"])
    total = len(results)

    return {
        "file": html_path,
        "pass_count": pass_count,
        "total": total,
        "pass_rate": round(pass_count / total * 100, 1),
        "results": results
    }


def main():
    if len(sys.argv) < 2:
        print("Usage: python grade.py <path-to-html>")
        sys.exit(1)

    html_path = sys.argv[1]
    result = grade_html(html_path)
    print(json.dumps(result, indent=2, ensure_ascii=False))

    # Also save as grading.json next to the HTML
    output_dir = Path(html_path).parent
    (output_dir / "grading.json").write_text(
        json.dumps(result, indent=2, ensure_ascii=False),
        encoding="utf-8"
    )
    print(f"\nSaved grading.json to {output_dir}")


if __name__ == "__main__":
    main()
