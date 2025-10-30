# Calendly Integration for the Consulting Page

This guide shows how to wire Calendly into the Ignite-powered site so prospects can book time directly from the consulting page. You can either link out to your booking page, display an inline widget, or trigger a pop-up scheduler.

---

## 1. Decide if Calendly Fits

- **Use it** if you expect async leads from multiple time zones, want automated reminders, or plan to sell fixed-time engagements (hour/day/week).  
- **Skip it** if you prefer vetting inquiries manually over email, or if your pipeline is currently light enough that hand-scheduling is faster. You can always add Calendly later; start with a simple mailto CTA and upgrade once bookings become frequent.

---

## 2. Prepare Calendly

1. Create or sign in to your Calendly account.  
2. Set your availability, buffer times, and minimum scheduling notice.  
3. Create dedicated Event Types for each offer (e.g. “Architecture Hour”, “Build Day Strategy Call”) and customise confirmation emails.  
4. Under **Share Your Link**, copy the direct booking URL for the event type you want to feature (for example: `https://calendly.com/mihaela-openapi/architecture-hour`).

---

## 3. Option A – Link Out (Fastest)

You already have a button on `Consulting`. Replace the `mailto:` target with your Calendly URL:

```swift
Link("Book a call", target: "https://calendly.com/mihaela-openapi/architecture-hour")
    .role(.primary)
    .target(.blank)
```

Add `.target(.blank)` so the booking flow opens in a new tab and keeps the reader on your site.

---

## 4. Option B – Inline Widget Embed

This keeps the entire booking flow inside the consulting page.

### 4.1 Add the Calendly assets

1. Create `sitebuilder/Includes/calendly-head.html` with the widget CSS and script:

```html
<link href="https://assets.calendly.com/assets/external/widget.css" rel="stylesheet">
<script src="https://assets.calendly.com/assets/external/widget.js" type="text/javascript" async></script>
```

2. Update `MainLayout` to include the snippet inside `Head`:

```swift
Head {
    Analytics(.custom("""
    <script defer src="https://cloud.umami.is/script.js" data-website-id="1ee8d39f-4184-4d60-89a3-13131860112a"></script>
    """))
    Include("calendly-head")
}
```

### 4.2 Add the widget markup to the consulting page

Create `sitebuilder/Includes/calendly-inline.html`:

```html
<div class="calendly-inline-widget"
     data-url="https://calendly.com/mihaela-openapi/architecture-hour"
     style="min-width:320px;height:720px;"></div>
```

Then, in `Consulting`, drop the widget where you want it to appear:

```swift
Section {
    Text("Pick a slot right away")
        .font(.title2)
        .margin(.bottom, .medium)

    Include("calendly-inline")
        .frame(maxWidth: .percent(100%))
}
.margin(.bottom, .xLarge)
```

Adjust the `data-url` attribute if you want to surface a different event type.

---

## 5. Option C – Pop-up Widget on Click

If you prefer a compact page but want Calendly on-demand:

1. Reuse the head include from Option B.  
2. Replace the CTA with:

```swift
Link("Schedule via Calendly", target: "#")
    .role(.primary)
    .attribute("onclick", "Calendly.initPopupWidget({url: 'https://calendly.com/mihaela-openapi/architecture-hour'});return false;")
```

Calendly’s script intercepts the click, opens the modal, and prevents navigation away from the page.

---

## 6. Test and Deploy

1. Run `swift build` to ensure the project still compiles (the includes are static HTML so this should be instant).  
2. Use `swift run IgniteStarter` (or your existing publish script) to regenerate the static HTML.  
3. Open the generated `Build/Consulting/index.html` locally and click through the widget or link to confirm the embed works.  
4. Deploy as usual. Remember that ad blockers or strict content security policies can block Calendly, so keep the email CTA as a fallback even after integrating scheduling.
