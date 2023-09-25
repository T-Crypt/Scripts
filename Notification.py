import time
from plyer import notification

# Set the title and message for the notification
title = "Daily Reminder"
message = "Don't forget to check testing"

# Set the notification interval in seconds (24 hours)
notification_interval = 24 * 60 * 60  # 24 hours * 60 minutes * 60 seconds

while True:
    # Display the notification
    notification.notify(
        title=title,
        message=message,
        app_name="Daily Reminder",
        timeout=10  # The notification will disappear after 10 seconds
    )

    # Wait for the next notification interval
    time.sleep(notification_interval)