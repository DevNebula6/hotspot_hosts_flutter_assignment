Flutter Internship Assignment
Build a Onboarding Questionnaire for Hotspot Hosts
Overview
Hotspot hosts are individuals who facilitate and manage events or gatherings at designated
locations known as hotspots. These hotspots are events where community interactions,
social engagements, or specific activities take place, aiming to foster connectivity and enrich
social experiences among participants. When someone applies to become a host on our
platform, a host questionnaire is used to assess their suitability and readiness for the role.
This questionnaire helps ensure that hosts are aligned with the values and goals of the
platform, possess the necessary skills to manage social gatherings effectively, and can
create an inviting and safe environment for all attendees. The screening process, facilitated
by the questionnaire, is crucial for maintaining the quality and consistency of the experiences
offered at various hotspots.

Assignment Breakdown
Tasks
1. Experience Type Selection Screen
Build a screen that displays a list of experiences fetched from a provided API.
Features:
● Add selection and deselection on each card.
● Add a multi-line textfield with a character limit of 250.
Requirements:
● Use a clean UI with proper spacing and styling.
● Display the experience card using image_url as background.
● The unselected state should have a grayscale version on the image.
● The user can select multiple cards.
● Store the selected experience ids and text in the state.
● Log the state on clicking next and redirect to next page.
2. Onboarding Question Screen
On clicking next on Experience selection screen, navigate to this page.

Features:
● Add multi-line textfield with a character limit of 600.
● Add support to record audio answer.
● Add support to record video answer.
● Handle the dynamic layout visuals as per the design. Remove the audio and video
recording buttons from the bottom if the corresponding asset is already recorded.
Requirements:
● Recording audio should show a waveform.
● Option to cancel while recording. (refer design)
● Option to delete a recorded audio or video.
● Playback for audio and video can be skipped as a part for the main requirements but
would hold brownie points.

Brownie Points (Optional Enhancements)
UI/UX:
● Try for a pixel perfect design. Refer spacings, fonts and colors from the figma file.
● Keep the UI responsive, handle cases when the keyboard is open and viewport
height is reduced.
State Management:
● Implement a state management solution such as Riverpod or BloC to manage state.
● Use Dio for managing the API call.
Animations:
● Experience Screen: On selection on the card animate and slide the card to first
index.
● Question Screen: Animate the Next button width when the record audio and video
buttons disappear.

Submission Guidelines
Code Quality:
● Write clean, readable code with proper comments where necessary.
● Structure the project in a scalable manner (e.g., separate screens, models, and
services directories).

GitHub Repository:
● Push your code to a GitHub repository and share the link as a reply to the
assignment email. (jatin@8club.co)
● Ensure the repository has a clear README explaining:
○ Features that you've implemented.
○ Brownie point items you've implemented.
○ Any additional features or enhancements you've implemented.

Working Demo Screen Recording:
● Attach a short demo clip of screen recording the app's functionalities.

Design Files
Figma Design Link

API Details
Get Experiences API
URL:
https://staging.chamberofsecrets.8club.co/v1/experiences?active=true
Method: GET
Response Example:
json
{
"message": "string",
"data": {
"experiences": [
{
"id": 0,
"name": "string",
"tagline": "string",
"description": "string",
"image_url": "string",
"icon_url": "string"
}
]
}

}