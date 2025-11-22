# Nature-Spots Project Overview

## Purpose
Nature-Spots is a review site for natural spots where users can share scenic locations with geolocation features. Users can post reviews, like posts, and interact with each other through follow functionality.

## Tech Stack

### Frontend
- **Framework**: Nuxt.js 3 (v3.10.3)
- **UI Library**: Vue.js 3 + Vuetify 3.7.16
- **Language**: TypeScript 5.7.3 (strict mode)
- **State Management**: Pinia 3.0.1
- **Styling**: SCSS/Sass
- **Internationalization**: Vue I18n (Japanese/English support)
- **Maps**: vue3-google-map (Google Maps JavaScript API, Geocoding API)
- **Utilities**: date-fns, crypto-js, @vueuse/core

### Backend
- **Framework**: Ruby on Rails 7.1.5
- **Language**: Ruby 3.2.3
- **Database**: MySQL 5.7
- **Authentication**: JWT (using jwt gem ~> 2.2)
- **Password Encryption**: bcrypt
- **Image Upload**: carrierwave
- **Security**: rack-attack (rate limiting), brakeman (security auditing)
- **Testing**: RSpec, FactoryBot, SimpleCov
- **Other Gems**: active_hash, hirb, nokogiri

### Infrastructure
- **Containerization**: Docker + Docker Compose
- **CI/CD**: CircleCI
- **Cloud**: AWS (VPC, ECS, ECR, RDS, Route53, ELB, ACM, IAM) - currently stopped

### API Integration
- Google Maps JavaScript API (map display)
- Google Geocoding API (location data from spot names)

## Key Features
- User registration and login (JWT-based)
- Guest login
- User follow/unfollow
- Spot posting with geolocation
- Reviews with image upload
- Like functionality
- Favorite spots management
- Search with autocomplete
- Browse by prefecture or genre
- Sort by review count
- Internationalization (Japanese/English)

## Architecture
- **SPA**: Frontend is a Single Page Application built with Nuxt.js
- **API Mode**: Backend runs in Rails API mode
- **Decoupled**: Frontend and backend are loosely coupled
- **RESTful API**: API versioning (v1) with consistent JSON responses
