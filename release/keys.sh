#!/bin/zsh

# Define keystore file paths
signing_keystore="/home/cda/.ssh/signing-keystore.jks"
upload_keystore="/home/cda/.ssh/upload-keystore.jks"

# Default output files
default_output_zip="out.zip"
default_encryption_key="encryption_public_key.pem"
default_upload_certificate="upload_certificate.pem"

# Functions to perform specific tasks
function export_app_signing_key() {
    local output_file="$1"
    local encryption_key="$2"
    if [[ -z "$output_file" ]]; then
        output_file="$default_output_zip"
    fi
    if [[ -z "$encryption_key" ]]; then
        encryption_key="$default_encryption_key"
    fi
    echo "Exporting app signing key signed with Google Playstore Key to $output_file"
    java -jar pepk.jar \
        --keystore="$signing_keystore" \
        --alias=appsign \
        --output="$output_file" \
        --include-cert \
        --rsa-aes-encryption \
        --encryption-key-path="$encryption_key"
}

function generate_upload_key() {
    echo "Creating upload key"
    keytool -genkey -v \
        -keystore "$upload_keystore" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -alias upload
}

function export_upload_key() {
    local output_certificate="$1"
    if [[ -z "$output_certificate" ]]; then
        output_certificate="$default_upload_certificate"
    fi
    echo "Exporting upload key to PEM format as $output_certificate"
    keytool -export -rfc \
        -keystore "$upload_keystore" \
        -alias upload \
        -file "$output_certificate"
}


# If no arguments are passed
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 [--appsign-export output_file.zip encryption_key.pem] [--generate-upload-key] [--export-upload-key upload_certificate.pem]"
    exit 1
fi

# Parse command-line arguments
while [[ "$1" != "" ]]; do
    case "$1" in
        --appsign-export)
            shift
            output_file="$1"
            shift
            encryption_key="$1"
            export_app_signing_key "$output_file" "$encryption_key"
            ;;
        --generate-upload-key)
            generate_upload_key
            ;;
        --export-upload-key)
            shift
            upload_certificate="$1"
            export_upload_key "$upload_certificate"
            ;;
        *)
            echo "Invalid argument: $1"
            echo "Usage: $0 [--appsign-export output_file.zip encryption_key.pem] [--generate-upload-key] [--export-upload-key upload_certificate.pem]"
            exit 1
            ;;
    esac
    shift
done
