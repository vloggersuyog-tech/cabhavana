# CA. Bhavana Tamhanekar website preview

A responsive no-build website with seven main sections: Home, About Us, Our Services, Book Consultation, Tax Calculator, Blog and Contact Us. It uses a light blue-grey, white, royal blue and sky blue palette, Arial/system fonts and a text-only name treatment. There is no logo or monogram.

## Open the preview

Open `index.html` in a modern browser. No package installation is needed. The hero illustration is drawn with CSS. Blog photos and Supabase form submissions need an internet connection.

## Working in this preview

- Responsive navigation, active page highlighting and mobile menu
- Exactly four service categories: Income Tax Services, GST Services, Accounting & Bookkeeping, and Audit & Assurance. Service detail dialogs and consultation links work.
- Six educational articles with full article dialogs, search, category filters, publication date labels and related article titles
- Indian income tax estimator for ordinary income under the specifically selected FY 2025–26 / AY 2026–27 rules. It compares regimes, applies standard deduction, old-regime deductions/exemptions, age-based old-regime slabs, applicable rebates, surcharge/marginal relief and cess.
- Browser validation for forms, Indian mobile format validation for booking enquiries
- Consultation and contact forms submit leads to the Supabase `public.leads` table using a publishable browser key and insert-only Row Level Security policy

## Not live / backend work remaining

The website files are connected to the Supabase project `ca-bhavana-website` in the `ap-south-1` region. Consultation and contact submissions are saved in `public.leads`; Row Level Security permits visitors to insert leads but does not allow public reads, edits or deletions. The publishable key in `supabase-config.js` is intended for browser use; never put a secret/service-role key there. Leads can currently be reviewed by authorized project members in the Supabase dashboard. There is no email notification, authenticated website admin dashboard, server-confirmed slot inventory, duplicate-booking prevention or built-in spam control. The forms do not confirm consultation availability.

Before public launch, configure suitable abuse protection, create an authenticated website admin area if needed, and finalize the privacy notice and data retention policy. Email notifications and automated booking confirmation require a verified email provider and additional setup. Test privacy, access control, data retention and recovery before use. The provided practice email is displayed as a mail link; verify the receiving mailbox with the email provider before enabling notifications. Add verified phone, address and hours. A map, click-to-call, or WhatsApp link should be added after those details are confirmed.

## Tax estimate scope

Rules checked against the [Income Tax Department's individual taxpayer guidance for AY 2026–27](https://www.incometax.gov.in/iec/foportal/help/individual/return-applicable-1) on 30 October 2026. The calculator assumes a resident individual and ordinary income only. It excludes special-rate income, many exemptions and taxpayer-specific conditions, rounding details, credits, losses, and some other complexities. It is an estimate, not an official assessment or advice. It does not silently claim to cover later financial years. Verify against the current official rules and authoritative test cases before relying on it in production.

## Editable items and professional review

Replace the portrait placeholder and contact placeholders when verified information is available. Audit engagements remain subject to applicable law, eligibility, independence and professional requirements. Review the final site and content against the [ICAI Code of Ethics, 13th edition](https://icai.org/post/prc-icai-press-release-12-12-2025) (effective 1 April 2026) and applicable professional requirements before publication.

## Files

- `index.html`, `styles.css`, `app.js`: website files
- `supabase-config.js`: Supabase project URL and publishable key (safe for browser exposure)
- `supabase/schema.sql`: private-record and content schema starter with row-level security
- `.env.example`: example future server-side configuration keys; no values are configured





