# NEXTCLOUD


### Nextcloud API

Upload folder recursively to Nextcloud

```bash
NEXTCLOUD_USER="your_username"
NEXTCLOUD_PASS="your_password"  
NEXTCLOUD_URL="nextcloud.aaa.com" 
LOCAL_FOLDER="./folder_to_upload"
NEXTCLOUD_FOLDER="/photos/2023"


# Function to ensure a directory exists on Nextcloud
ensure_directory() {
    DIR_PATH="$1"
    # Split the directory path into components
    IFS='/' read -ra ADDR <<< "$DIR_PATH"
    PARTIAL_PATH=""

    for i in "${ADDR[@]}"; do
        # Skip empty parts
        if [ -z "$i" ]; then
            continue
        fi
        PARTIAL_PATH="$PARTIAL_PATH/$i"
        FULL_PATH="https://$NEXTCLOUD_URL/remote.php/dav/files/$NEXTCLOUD_USER$PARTIAL_PATH"

        # Check if the directory exists by attempting to list it
        if ! curl -sf -u $NEXTCLOUD_USER:$NEXTCLOUD_PASS -X PROPFIND "$FULL_PATH"; then
            # Try to create the directory
            if ! curl -sf -u $NEXTCLOUD_USER:$NEXTCLOUD_PASS -X MKCOL "$FULL_PATH" -k; then
                echo "Failed to create directory $FULL_PATH"
                return 1
            fi
        fi
    done
    return 0
}

find "$LOCAL_FOLDER" -type f | while read FILE
do
    # Get the relative path from LOCAL_FOLDER
    REL_PATH="${FILE#$LOCAL_FOLDER/}"

    # Create the Nextcloud folder path
    NEXTCLOUD_DEST="https://$NEXTCLOUD_URL/remote.php/dav/files/$NEXTCLOUD_USER/$NEXTCLOUD_FOLDER/$REL_PATH"

    # Ensure the parent directory exists on Nextcloud
    DIR_PATH=$(dirname "$NEXTCLOUD_FOLDER/$REL_PATH")
    if ! ensure_directory "$DIR_PATH"; then
        echo "Failed to ensure directory $DIR_PATH exists"
        continue
    fi

    RESPONSE=$(curl -w "%{http_code}" -o /dev/null -u $NEXTCLOUD_USER:$NEXTCLOUD_PASS -T "$FILE" "$NEXTCLOUD_DEST")

    if [ "$RESPONSE" -eq 201 ] || [ "$RESPONSE" -eq 204 ]; then
        echo "Successfully uploaded $FILE to $NEXTCLOUD_DEST"
    else
        echo "Failed to upload $FILE to $NEXTCLOUD_DEST: HTTP status $RESPONSE"
    fi
done
```


