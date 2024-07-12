# SunShield

## Overview

SunShield is an app designed to help you manage sun exposure and protect your skin. It gathers your device's location, fetches current weather data from the [OpenWeatherMap API](https://home.openweathermap.org/), and calculates the time until sunburn based on your skin type, SPF, and the UV index at your location. The app sends a notification when it's time to reapply sunscreen.


https://github.com/mattauc/SunShield/assets/63832577/ccac5b54-2e05-4f6f-9370-b28950dcc7c8


## Features

- **Location-Based UV Monitoring:** Automatically fetches UV index data based on your device's location.
- **Personalized Sunburn Timer:** Calculates sunburn risk based on your skin type.
- **Reapplication Notifications:** Alerts you when it's time to reapply sunscreen.

## Getting Started

### Initial Setup

1. **Open the App:** When you first launch SunShield, you will be prompted to select your skin type and current SPF level. 
2. **Change Settings Anytime:** You can update your skin type and SPF settings at any time through the app interface.

### Using the Timer

1. **Start the Timer:** After applying sunscreen, press the start button on the timer.
2. **Receive Notifications:** The app will notify you when it's time to reapply sunscreen based on the calculated sunburn time.

## Technical Details

- **Languages and Frameworks:** The app is built using Swift and SwiftUI, leveraging the Combine framework for asynchronous data handling.
- **Proxy Server:** A proxy server is set up to call the OpenWeather API and relay the data back to the application.
