# PlantKiller
## Product Requirements Document

**The Plant App for People Who Kill Plants**

---

**Version:** 1.0 (MVP)
**Date:** January 2026
**Status:** Draft

---

## Executive Summary

PlantKiller is a mobile app designed for people who repeatedly kill houseplants. Unlike existing plant care apps that target enthusiasts, PlantKiller acknowledges that most users will forget to water their plants and builds its entire experience around making that impossible through escalating notifications, humor, and light gamification.

The app uses a tiered plant difficulty system that prevents beginners from taking on plants beyond their proven ability, a graveyard memorial for dead plants that uses guilt as motivation, and a funny/snarky notification tone that makes the reminders tolerable rather than annoying.

---

## Problem Statement

### The Problem

Millions of people buy houseplants with good intentions but kill them through neglect. Existing plant care apps like Planta and Greg target plant enthusiasts with comprehensive features and gentle reminders. However, these apps fail the actual target market: people who have killed multiple plants and need aggressive intervention to change their behavior.

**Core issues:**
- Gentle reminders are easy to ignore
- Existing apps assume users are already competent or motivated
- There is no accountability system for chronic plant neglectors
- Beginners often buy plants that are too difficult for their skill level

### Target Market

**Primary Users:**
- People who have killed multiple houseplants
- Gift recipients who received a plant and do not know what to do
- Apartment dwellers with 1-5 plants
- Ages 25-40, busy professionals
- Want plants for aesthetics but lack knowledge or discipline

**Not Targeting:**
- Plant enthusiasts (they already use Planta/Greg)
- Serious gardeners with extensive collections
- People with 20+ plants who need inventory management

### Market Opportunity

No existing app specifically targets the plant-killing demographic. All competitors assume competent, motivated users. PlantKiller fills this gap with honest positioning and features designed for people who have failed before.

---

## Product Overview

### Core Concept

A reminder-first plant care app that assumes users will forget and uses escalating notifications, humor, and guilt to keep plants alive. The app is fundamentally a smart reminder system with personality, not a verification or tracking system.

### Tagline

*"The Plant App for People Who Kill Plants"*

### Key Differentiators

- Only app that admits most people kill plants
- Impossible-to-ignore escalating notification system
- Tiered unlock system prevents beginners from taking on difficult plants
- Dead plant memorial/graveyard uses guilt and humor as motivation
- Funny/snarky default tone makes reminders tolerable

---

## Core Features (MVP)

### 1. Plant Dashboard

The main screen displays the user's active plants in a visual grid format.

#### Grid View
- Grid of plant cards showing isometric plant image and plant name
- Tapping a plant opens the detailed plant card
- Empty state shows friendly prompt to add first plant

#### Plant Detail Card

When user taps a plant from the grid, they see:
- Plant name (user-assigned)
- 3D isometric plant image
- User-provided photo (if uploaded)
- Days since last watered ("Watered 2 days ago")
- Next watering due ("Water tomorrow" or "Water today!")
- Simple status indicator (green checkmark / yellow warning / red alert)

#### Plant Card Actions
- Confirm watering button (double checkmark for confirmation)
- Edit plant (rename, change watering schedule)
- Delete plant (moves to graveyard with undo option)
- Move to graveyard (mark as dead)

---

### 2. Escalating Notification System

The core feature of the app. Notifications escalate in urgency over several days if watering is not confirmed.

#### Notification Behavior
- Fires at user's preferred time (set in settings)
- One notification per day maximum
- Batched for multiple plants ("3 plants need water: Fern, Pothos, Snake Plant")
- Funny/snarky default tone
- Escalation continues regardless of snooze/delay
- Specific escalation timeline TBD (will define day triggers during development)
- Plants auto-move to graveyard after X days ignored (threshold TBD)

#### Sample Notification Copy (Funny/Snarky Tone)
- **Day 1:** "Time to water your pothos! It's judging you right now."
- **Day 3:** "URGENT: Your plant needs water NOW. This is getting personal."
- **Day 5:** "It's been 5 days. At this point you're just watching it die slowly."
- **Day 7+:** Photo of dead plant - "This is your future."

---

### 3. Tiered Plant Library & Unlock System

Plants are organized by difficulty tiers. Users must prove competence with easier plants before unlocking harder ones.

#### Tier Structure (MVP: 10 plants)

| Tier | Difficulty | Plants | Unlock Requirement |
|------|------------|--------|-------------------|
| 1 | Beginner | 4 plants | Unlocked by default |
| 2 | Intermediate | 4 plants | Keep plants alive for 30 days |
| 3 | Advanced | 2 plants | Keep plants alive for 60 days |
| 4 | Expert | Future update | TBD |

#### Locked Plant Behavior
- Locked plants show full color with lock icon overlay
- Tapping locked plant shows unlock requirements
- "I already own this" bypass button available for all locked tiers
- Bypass requires two taps: first shows warning, second confirms add
- Bypassed plants show visual warning indicator (e.g., red triangle) until tier is legitimately unlocked

#### Add Plant Flow
1. User taps floating "+" button
2. Plant library opens (vertical scroll, organized by tiers)
3. User taps plant to see mini info card (care tips, difficulty rating)
4. User taps "Add this plant"
5. Schedule setup screen shows recommended watering frequency
6. User accepts recommended or customizes with scroll wheel
7. User optionally names the plant
8. Plant added to dashboard

---

### 4. Graveyard (Dead Plant Memorial)

A dedicated tab showing all plants that have died under the user's care. Uses guilt and humor as motivation.

#### Graveyard Features
- Grid view of dead plants
- Each dead plant shown as tombstone with plant's isometric image and name
- Tapping shows memorial card with survival stats (days survived)
- 7-day resurrection window for accidentally deleted or auto-dead plants
- Empty graveyard message: "No dead plants yet - keep it that way!"

#### Auto-Death Mechanism
Plants automatically move to graveyard after X days of ignored notifications. The app prompts user to confirm status before finalizing. This threshold will be determined during development.

---

### 5. Settings

Minimal settings for MVP, focused on core functionality.

#### MVP Settings
- Notification timing preferences (default reminder time)
- Subscription management (via Superwall)
- About / credits
- Contact support / feedback

---

## User Experience

### Navigation Structure

Two-tab navigation with floating action button:
- **Tab 1:** My Plants (dashboard with plant grid)
- **Tab 2:** Graveyard (dead plant memorial)
- **Floating "+" button:** Opens plant library to add new plants
- **Settings:** Accessible via gear icon in top corner

### Onboarding Flow

Minimal onboarding designed to get users to their first plant quickly:

1. "Have you ever killed a plant?" (humor/tone-setting question)
2. Full plant library displayed (Tier 1 unlocked, others locked with bypass)
3. User selects plant, sees recommended watering schedule
4. User accepts or customizes schedule with scroll wheel
5. User optionally names plant
6. Done - user lands on dashboard with first plant

### Edge Cases & Error States

#### Notifications Disabled
If user disables notifications at the OS level, show persistent banner on dashboard: "Notifications are off - your plants will die!"

#### Prolonged Absence
If user does not open app for extended period, plants auto-move to graveyard after the defined threshold of ignored notifications.

#### Accidental Deletion
Deleted plants move to graveyard with 7-day resurrection option, same as dead plants.

#### New Phone / Data Loss
No cloud sync in MVP. User data is device-local only. This is acceptable for MVP; iCloud backup will be added in V2.

---

## Technical Specification

### Tech Stack

| Layer | Technology | Notes |
|-------|------------|-------|
| Language/UI | Swift + SwiftUI | Native iOS development |
| Architecture | Lightweight MV with @Observable | MVVM where complexity warrants |
| Backend + Database | Firebase (Firestore) | NoSQL document database |
| Push Notifications | Firebase Cloud Messaging | Reliable scheduled notifications |
| Scheduled Jobs | Firebase Cloud Functions | Check watering schedules, trigger notifications |
| Subscriptions & Paywalls | Superwall | Handles paywalls, A/B testing, and subscription logic |
| Analytics | PostHog | Post-MVP addition |

### Platform
- iOS only for MVP (requires iOS 16+)
- Android: Post-launch based on demand

### Why This Stack

#### Swift + SwiftUI over React Native
App is iOS-focused with no immediate Android plans. SwiftUI provides simpler toolchain, better performance, and native platform learning. If Android demand materializes later, rebuild is acceptable.

#### Firebase over Supabase
Push notifications are core to this app. Firebase Cloud Messaging is built-in and battle-tested. Supabase would require adding FCM anyway. Firebase also provides excellent offline support.

#### Superwall over raw StoreKit
Subscription code and paywall design are complex to implement correctly. Superwall handles paywalls with remote configuration (change paywall UI without app updates), built-in A/B testing for conversion optimization, and subscription management. Free tier available for early-stage apps.

### Data Model (Simplified)

**User**
Device-local user preferences including notification time, subscription status, and tier unlock progress.

**Plant**
Name, plant type ID, watering schedule (days), last watered date, date added, warning badge status (for bypassed plants).

**Graveyard Entry**
Plant reference, death date, days survived, resurrection deadline.

**Plant Database (Static)**
10 plants for MVP with common name, difficulty tier, recommended watering frequency, and care tips. Database maintained manually.

---

## Monetization

### Pricing Model

Freemium subscription model with no ads.

#### Free Tier
- Up to 2 plants
- Basic notifications with escalation
- Access to Tier 1 plants
- Full graveyard functionality

#### Premium Tier
- Unlimited plants
- Access to locked tiers with warning badge (bypass feature)
- Price TBD ($2.99-4.99/month range)
- Will offer monthly subscription option

### Revenue Projections
To be determined based on user acquisition and conversion data post-launch.

---

## Brand & Design

### App Name
PlantKiller (working title, may change before launch)

### Brand Voice
- Self-deprecating humor
- Honest and blunt
- Encouraging but not patronizing
- Relatable ("we've all killed plants")
- Slightly sassy

### Visual Style
- 3D isometric plant illustrations (style similar to Viridi game)
- Clean, minimal UI with visual focus on plant images
- Tombstone imagery for graveyard
- Status indicators: green/yellow/red color coding
- Placeholder images for MVP; custom art created later

### App Icon
To be determined.

---

## Launch Plan

### Beta Testing
Small group of friends via TestFlight before public launch.

### App Store
- Category: TBD (likely Lifestyle or Productivity)
- Keywords and ASO strategy: TBD
- App Store listing copy: TBD

### Marketing
Launch marketing plans to be determined post-build. Potential channels include Product Hunt, Reddit (r/houseplants, r/plantclinic), and TikTok content.

### Success Metrics
To be defined post-build. Potential metrics include downloads, 30-day retention, premium conversion rate, and average plant survival time.

---

## Future Roadmap (V2 and Beyond)

### V2 Features
- Notification personality picker (Funny/Gentle/Brutal/Motivational)
- Notification timing preferences in settings
- Emergency contact / accountability partner (app-to-app)
- Streak count display on plant cards
- User accounts and iCloud backup/sync
- Memorial messages and photos for dead plants
- Shareable graveyard screenshots
- Search bar in plant library
- Request a plant form
- PostHog analytics integration

### V3+ Considerations
- Plant health score system
- Visual plant states (healthy vs wilting)
- Light requirement reminders
- Android version
- Tier 4 plants (expert difficulty)
- Weather integration for outdoor plants
- Social features and friend challenges

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Users uninstall due to annoying notifications | Medium | High | Make notifications funny, not just annoying. Personality and humor make them tolerable. |
| Plant database accuracy issues | Low | Medium | Start with 10 well-researched common plants. Conservative watering schedules (err on under-watering). |
| Users game the system (confirm without watering) | Medium | Low | App is reminder-focused, not verification-focused. Users only hurt themselves. |
| Competition from established apps | Low | Medium | Completely different positioning. Target underserved market segment. |
| Data loss on phone switch (no sync) | Medium | Medium | Acceptable for MVP. iCloud backup in V2. |

---

## Competitive Analysis

| App | Target User | Approach | Gap PlantKiller Fills |
|-----|-------------|----------|----------------------|
| Planta | Plant enthusiasts | Beautiful UI, comprehensive features, $8/mo | Too expensive, assumes serious users, gentle reminders |
| Greg | Intermediate users | Watering-focused, condition adjustments | Assumes competent user, reminders easy to ignore |
| Vera | General users | Simple reminders | Generic, no personality, no accountability |
| Happy Plant | General users | Streak tracking, time-lapse | Friendly approach, missing escalation and guilt |

**Market Gap:** No app currently targets the "I've killed 5 plants and I'm scared to try again" market. All competitors assume users are plant enthusiasts. That's the opportunity.

---

## Appendix

### A. MVP Feature Summary Checklist

- [ ] Plant grid dashboard with isometric images + names
- [ ] Plant detail card with watering info and status
- [ ] Add plant flow (library -> info -> schedule -> optional name)
- [ ] Tiered plant library (10 plants: 4/4/2 across tiers)
- [ ] Tier unlock system (30 days / 60 days)
- [ ] "I already own this" bypass with warning
- [ ] Watering reminders (user-set time, batched, escalating)
- [ ] Funny/snarky notification copy
- [ ] Confirm watering (double checkmark)
- [ ] Graveyard tab (tombstone grid)
- [ ] 7-day resurrection from graveyard
- [ ] Auto-death after X days ignored
- [ ] Settings (notification time, subscription, about, support)
- [ ] 2 plants free, premium for unlimited
- [ ] Superwall subscription/paywall integration
- [ ] Notification-disabled warning banner
- [ ] Onboarding flow

### B. Out of Scope for MVP

- Notification personality picker
- Emergency contact / accountability partner
- Streak count display
- Plant health score
- User accounts / cloud sync
- Memorial messages/photos
- Shareable graveyard
- Search in plant library
- Request a plant form
- PostHog analytics
- Android

### C. Open Questions

- Specific escalation notification timeline (days and copy)
- Auto-death threshold (days of ignored notifications)
- Exact subscription pricing
- Final app name and icon
- Specific plants for MVP database (10 common houseplants)
- App Store category and ASO strategy
- Success metrics and targets

---

*— End of Document —*
