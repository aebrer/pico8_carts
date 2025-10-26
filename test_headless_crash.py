#!/usr/bin/env python3
"""
Test script to reproduce EditART's Chrome headless crash
Simulates their preview capture system
"""

import time
import tempfile
import shutil
import random
import os
from datetime import datetime
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Create test results directory
RESULTS_DIR = "test_results"
os.makedirs(RESULTS_DIR, exist_ok=True)

def test_headless_crash(viewport_width=1920, viewport_height=1080):
    """
    Test the piece in Chrome headless with various viewport sizes
    """
    print(f"\n{'='*60}")
    print(f"Testing with viewport: {viewport_width}x{viewport_height}")
    print(f"{'='*60}\n")

    # Create unique temp directory for this test
    temp_dir = tempfile.mkdtemp(prefix=f"chrome_test_{viewport_width}x{viewport_height}_")

    # Set up Chrome options (headless mode like EditART)
    chrome_options = Options()
    chrome_options.binary_location = "/usr/bin/chromium-browser"  # Use chromium on WSL2
    chrome_options.add_argument("--headless=new")  # New headless mode
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument(f"--window-size={viewport_width},{viewport_height}")
    chrome_options.add_argument(f"--user-data-dir={temp_dir}")

    # Enable WebGL in headless (like EditART's setup)
    chrome_options.add_argument("--use-gl=swiftshader")  # Software WebGL rendering
    chrome_options.add_argument("--enable-webgl")
    chrome_options.add_argument("--ignore-gpu-blocklist")

    # Use unique debug port for each test to avoid conflicts
    debug_port = random.randint(9222, 9999)
    chrome_options.add_argument(f"--remote-debugging-port={debug_port}")  # WSL2 fix

    # Enable logging
    chrome_options.add_argument("--enable-logging")
    chrome_options.add_argument("--v=1")

    driver = None

    try:
        print("🚀 Launching Chrome headless...")
        driver = webdriver.Chrome(options=chrome_options)

        # Use CDP to set exact viewport size (matches EditART's server environment)
        driver.execute_cdp_cmd('Emulation.setDeviceMetricsOverride', {
            'width': viewport_width,
            'height': viewport_height,
            'deviceScaleFactor': 1,
            'mobile': False
        })

        # Navigate to local test page
        url = "http://127.0.0.1:8069/series/screensavers/the_seed_marche/"
        print(f"📍 Navigating to: {url}")
        driver.get(url)

        # Wait for canvas to be created
        print("⏳ Waiting for canvas element...")
        canvas = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "artCanvas"))
        )
        print(f"✓ Canvas found: {canvas.size['width']}x{canvas.size['height']}")

        # Check console for errors
        print("\n📋 Console logs:")
        console_logs = driver.get_log('browser')
        errors = []
        warnings = []
        for entry in console_logs:
            level = entry['level']
            message = entry['message']
            print(f"  [{level}] {message}")
            if level == 'SEVERE':
                # Ignore favicon 404 - it's irrelevant
                if 'favicon.ico' not in message:
                    errors.append(message)
            elif level == 'WARNING':
                warnings.append(message)

        # Wait for animation to start (simulate preview trigger delay)
        print("\n⏳ Waiting 5 seconds for animation...")
        time.sleep(5)

        # Validate canvas rendering
        print("\n🔍 Validating canvas...")
        canvas_width = driver.execute_script("return document.getElementById('artCanvas').width")
        canvas_height = driver.execute_script("return document.getElementById('artCanvas').height")
        print(f"  Canvas size: {canvas_width}x{canvas_height}")

        # Check if canvas is default size (indicates initialization failure)
        is_default_size = canvas_width == 300 and canvas_height == 150
        if is_default_size:
            errors.append("Canvas is default size 300x150 (initialization failed)")

        # Check if canvas is unreasonably large (could cause memory issues)
        max_dimension = max(canvas_width, canvas_height)
        is_too_large = max_dimension > 8000
        if is_too_large:
            print(f"  ⚠️  Warning: Canvas is very large ({canvas_width}x{canvas_height}), may cause memory issues")

        # Try to take a screenshot (this is what EditART does)
        print("\n📸 Attempting screenshot...")
        screenshot = driver.get_screenshot_as_png()
        print(f"✓ Screenshot captured: {len(screenshot)} bytes")

        # Check memory usage
        print("\n💾 Memory info:")
        memory_info = driver.execute_script("return performance.memory")
        if memory_info:
            print(f"  Used: {memory_info.get('usedJSHeapSize', 0) / 1024 / 1024:.2f} MB")
            print(f"  Total: {memory_info.get('totalJSHeapSize', 0) / 1024 / 1024:.2f} MB")
            print(f"  Limit: {memory_info.get('jsHeapSizeLimit', 0) / 1024 / 1024:.2f} MB")

        # Determine pass/fail based on validation
        # Success = canvas initialized (not default size) and no SEVERE errors
        test_passed = not is_default_size and len(errors) == 0

        # Generate timestamp for filenames
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        status = "PASS" if test_passed else "FAIL"
        base_filename = f"{timestamp}_{viewport_width}x{viewport_height}_{status}"

        # Save screenshot with timestamp and status
        screenshot_path = os.path.join(RESULTS_DIR, f"{base_filename}.png")
        with open(screenshot_path, 'wb') as f:
            f.write(screenshot)
        print(f"\n💾 Screenshot saved to: {screenshot_path}")

        # Get actual screenshot dimensions using PIL
        from PIL import Image
        import io
        img = Image.open(io.BytesIO(screenshot))
        actual_width, actual_height = img.size
        print(f"  Actual screenshot dimensions: {actual_width}x{actual_height}")

        # Save console logs
        log_path = os.path.join(RESULTS_DIR, f"{base_filename}.log")
        with open(log_path, 'w') as f:
            f.write(f"Test: {viewport_width}x{viewport_height}\n")
            f.write(f"Status: {status}\n")
            f.write(f"Canvas size: {canvas_width}x{canvas_height}\n")
            f.write(f"Screenshot dimensions: {actual_width}x{actual_height}\n")
            f.write(f"Is too large: {is_too_large}\n")
            f.write(f"\n{'='*60}\n")
            f.write("Console Logs:\n")
            f.write(f"{'='*60}\n\n")
            for entry in console_logs:
                f.write(f"[{entry['level']}] {entry['message']}\n")
            if errors:
                f.write(f"\n{'='*60}\n")
                f.write("ERRORS:\n")
                f.write(f"{'='*60}\n")
                for error in errors:
                    f.write(f"  {error}\n")
            if warnings:
                f.write(f"\n{'='*60}\n")
                f.write("WARNINGS:\n")
                f.write(f"{'='*60}\n")
                for warning in warnings:
                    f.write(f"  {warning}\n")
        print(f"💾 Console logs saved to: {log_path}")

        if test_passed:
            print("\n✅ Test PASSED! Canvas initialized, no errors detected.")
        else:
            print("\n❌ Test FAILED!")
            if is_default_size:
                print("  - Canvas is default size (initialization failed)")
            if errors:
                print(f"  - {len(errors)} SEVERE error(s) in console")

        return test_passed

    except Exception as e:
        print(f"\n❌ Error: {type(e).__name__}: {e}")

        # Try to save crash info
        try:
            timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
            base_filename = f"{timestamp}_{viewport_width}x{viewport_height}_CRASH"

            # Save screenshot if possible
            try:
                screenshot = driver.get_screenshot_as_png()
                screenshot_path = os.path.join(RESULTS_DIR, f"{base_filename}.png")
                with open(screenshot_path, 'wb') as f:
                    f.write(screenshot)
                print(f"💾 Crash screenshot saved to: {screenshot_path}")
            except:
                pass

            # Save console logs
            print("\n📋 Console logs at time of crash:")
            console_logs = driver.get_log('browser')
            log_path = os.path.join(RESULTS_DIR, f"{base_filename}.log")
            with open(log_path, 'w') as f:
                f.write(f"Test: {viewport_width}x{viewport_height}\n")
                f.write(f"Status: CRASH\n")
                f.write(f"Error: {type(e).__name__}: {e}\n")
                f.write(f"\n{'='*60}\n")
                f.write("Console Logs at Crash:\n")
                f.write(f"{'='*60}\n\n")
                for entry in console_logs:
                    level = entry['level']
                    message = entry['message']
                    f.write(f"[{level}] {message}\n")
                    print(f"  [{level}] {message}")
            print(f"💾 Crash logs saved to: {log_path}")
        except:
            pass

        return False

    finally:
        if driver:
            print("\n🔚 Closing browser...")
            driver.quit()

        # Clean up temp directory
        try:
            shutil.rmtree(temp_dir)
        except:
            pass

if __name__ == "__main__":
    print("🧪 Chrome Headless Crash Test")
    print("Testing the_seed_marche piece")

    # Test with various viewport sizes
    test_cases = [
        (1024, 1024),  # Square viewport
        (1920, 1080),  # Standard desktop
        (1280, 720),   # Smaller desktop
        (800, 600),    # Small window
        (3840, 2160),  # 4K (previously caused massive 6048x6048 canvas!)
    ]

    results = []
    for width, height in test_cases:
        success = test_headless_crash(width, height)
        results.append((width, height, success))
        time.sleep(2)  # Brief pause between tests

    # Summary
    print(f"\n{'='*60}")
    print("📊 Test Summary")
    print(f"{'='*60}")
    passed = sum(1 for _, _, success in results if success)
    total = len(results)
    for width, height, success in results:
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"  {width}x{height}: {status}")
    print(f"\nTotal: {passed}/{total} passed")
    print(f"\n💾 All results saved to: {RESULTS_DIR}/")
