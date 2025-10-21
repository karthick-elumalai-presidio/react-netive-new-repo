#!/bin/bash

echo "🔍 Checking for iOS Distribution Certificates on your Mac..."
echo ""
echo "=================================================="
echo "CERTIFICATES IN YOUR KEYCHAIN:"
echo "=================================================="
echo ""

# Check for Apple Distribution certificates
echo "📱 Looking for 'Apple Distribution' certificates (for App Store):"
security find-identity -v -p codesigning | grep "Apple Distribution" || echo "   ❌ None found"
echo ""

# Check for iOS Distribution certificates (old name)
echo "📱 Looking for 'iOS Distribution' certificates (old name):"
security find-identity -v -p codesigning | grep "iOS Distribution" || echo "   ❌ None found"
echo ""

# Check for Apple Development certificates
echo "🧪 Looking for 'Apple Development' certificates (for testing):"
security find-identity -v -p codesigning | grep "Apple Development" || echo "   ❌ None found"
echo ""

# Check for Developer ID Application (wrong type)
echo "💻 Looking for 'Developer ID Application' certificates (for Mac apps only):"
security find-identity -v -p codesigning | grep "Developer ID Application" || echo "   ❌ None found"
echo ""

echo "=================================================="
echo "SUMMARY:"
echo "=================================================="
echo ""

has_distribution=$(security find-identity -v -p codesigning | grep -c "Apple Distribution\|iOS Distribution")
has_development=$(security find-identity -v -p codesigning | grep -c "Apple Development")

if [ "$has_distribution" -gt 0 ]; then
    echo "✅ You HAVE Apple Distribution certificate(s)"
    echo "   → You can build for App Store/TestFlight"
    echo "   → Export one of these and update CSC_LINK secret"
    echo ""
    echo "📋 To export, run:"
    echo "   1. Open Keychain Access"
    echo "   2. Find 'Apple Distribution' certificate"
    echo "   3. Right-click → Export"
    echo "   4. Save as .p12 with password"
    echo "   5. Run: base64 -i /path/to/cert.p12 | pbcopy"
    echo "   6. Update GitHub secret CSC_LINK"
else
    echo "❌ You DON'T HAVE Apple Distribution certificates"
    echo "   → You CANNOT build for App Store/TestFlight yet"
    echo ""
    
    if [ "$has_development" -gt 0 ]; then
        echo "⚠️  You have Apple Development certificates"
        echo "   → You CAN build for local testing only"
        echo "   → Want me to configure workflow for development builds?"
    else
        echo "❌ You DON'T HAVE any Apple certificates for iOS"
    fi
    echo ""
    echo "🔧 To create Apple Distribution certificate:"
    echo "   1. Go to: https://developer.apple.com/account/resources/certificates/list"
    echo "   2. Click '+' to add new"
    echo "   3. Select 'Apple Distribution'"
    echo "   4. Follow the wizard"
fi

echo ""
echo "=================================================="

