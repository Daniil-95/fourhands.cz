-- Content is now maintained in the dedicated page sections in the admin.
DELETE FROM site_settings
WHERE key_name IN (
    'hero_image', 'hero_heading', 'hero_lead', 'hero_scroll',
    'about_image', 'about_heading', 'about_eyebrow', 'about_cta',
    'stat_1_number', 'stat_1_label',
    'stat_2_number', 'stat_2_label',
    'stat_3_number', 'stat_3_label',
    'member_katerina_image', 'member_irena_image'
);