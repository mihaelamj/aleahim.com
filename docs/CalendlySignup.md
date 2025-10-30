# Calendly Free Registration & Site Integration

Follow these steps to create a free Calendly account and hook it into the Ignite-powered consulting page.

---

## 1. Create Your Calendly Account

1. Visit [https://calendly.com/signup](https://calendly.com/signup).  
2. Choose **Continue with email** to stay on the free plan (Google/Apple login works too, but email keeps the flow simple).  
3. Enter your name, work email, and create a password.  
4. Calendly sends a verification link—open it within 24 hours to activate the account.

> The free tier includes one active event type and basic reminders, which is enough to start booking consulting calls.

---

## 2. Complete the Onboarding Wizard

1. **Availability:** Set your default working hours and time zone. You can add buffer times and minimum scheduling notice; keep them conservative to avoid surprise bookings.  
2. **Meeting Location:** Select Video Conferencing → “Add Custom” and paste your preferred meeting link (e.g. Zoom, Google Meet, or a static Jitsi URL).  
3. **Event Name:** Give it a clear title such as “Architecture Hour – OpenAPI Review”.  
4. **Duration:** Match your offer (60 minutes for hourly, 30 if it’s just an intro call).  
5. Finish and land on your new Event Type dashboard.

---

## 3. Configure Event Details

Inside your event, tweak these sections before sharing:

- **Availability:** Override days/times if the default calendar is too broad.  
- **Invitee Questions:** Ask for codebase context or goals (“What problem are you trying to solve with OpenAPI?”).  
- **Notifications and Cancellation Policy:** The free plan covers email reminders; specify a 24-hour cancellation window if you need prep time.  
- **Confirmation Page:** Add a short note reminding clients to send repo access or any docs ahead of the session.

Click **Save & Close** once everything looks right.

---

## 4. Grab Your Scheduling Link or Embed Code

1. From the event page, select **Share** → **Copy Link**.  
2. For inline or pop-up embeds, click **Add to Website** and choose the format you want. Calendly generates the HTML snippet plus the Javascript include.

Keep that URL/snippet handy—you’ll wire it into the site in the next step.

---

## 5. Add Calendly to the Ignite Site

Choose a delivery method:

- **Simple link:** Replace the mailto CTA with your Calendly URL.  
- **Inline widget or pop-up:** Follow `docs/CalendlyIntegration.md` for the exact include files and Swift snippets.

Remember to run `swift build` and regenerate the static HTML after you update the consulting page.

---

## 6. Test the Booking Flow

1. Open the local build (e.g. `sitebuilder/Build/consulting/index.html`).  
2. Click the Calendly link or widget and confirm:
   - Time zones display correctly.  
   - Confirmation emails hit your inbox.  
   - The meeting link in the event matches your preferred video app.
3. If everything looks good, publish the site update.

You’re now ready to take bookings on the free Calendly plan while keeping the email fallback in place. Upgrade later if you need multiple event types or advanced automation. 
