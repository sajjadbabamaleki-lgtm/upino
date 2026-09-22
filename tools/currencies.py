"""The single currency table both engines are generated from.

Columns: code, ISO 4217 exponent, display symbol, ISO 3166-1 alpha-2 of the
country whose flag represents it, country or region name, currency name.

Exponents follow ISO 4217, with one deliberate exception noted at IRR.

Symbols are only given as a glyph where that glyph renders in the fonts a
phone actually ships with. Everywhere else the ISO code stands in, because a
missing-glyph box next to someone's balance is worse than three letters.

Order is the order the picker offers them in, and it is a judgement, not a
measurement: the ten most-traded currencies by BIS turnover first, then the
Gulf and Iran, then the rest by the size of the economy behind them and by
region. Search is what people will actually use past the first screen.
"""

# code, exp, symbol, flag country, country/region, currency name
TABLE = [
    # The most-traded currencies, BIS Triennial Survey ordering.
    ('USD', 2, '$',  'US', 'United States',        'US dollar'),
    ('EUR', 2, '€',  'EU', 'Eurozone',             'Euro'),
    ('JPY', 0, '¥',  'JP', 'Japan',                'Japanese yen'),
    ('GBP', 2, '£',  'GB', 'United Kingdom',       'Pound sterling'),
    ('CNY', 2, '¥',  'CN', 'China',                'Chinese yuan'),
    ('AUD', 2, '$',  'AU', 'Australia',            'Australian dollar'),
    ('CAD', 2, '$',  'CA', 'Canada',               'Canadian dollar'),
    ('CHF', 2, 'Fr', 'CH', 'Switzerland',          'Swiss franc'),
    ('HKD', 2, '$',  'HK', 'Hong Kong',            'Hong Kong dollar'),
    ('SGD', 2, '$',  'SG', 'Singapore',            'Singapore dollar'),

    # The Gulf and Iran.
    ('AED', 2, 'AED', 'AE', 'United Arab Emirates', 'UAE dirham'),
    ('SAR', 2, 'SAR', 'SA', 'Saudi Arabia',         'Saudi riyal'),
    # ISO 4217 assigns IRR two decimals, but the rial has had no subunit in
    # circulation for decades. Nobody types rial cents, so the app does not
    # ask for them. Deliberate, and matched on both engines.
    ('IRR', 0, 'IRR', 'IR', 'Iran',                 'Iranian rial'),
    ('OMR', 3, 'OMR', 'OM', 'Oman',                 'Omani rial'),
    ('QAR', 2, 'QAR', 'QA', 'Qatar',                'Qatari riyal'),
    ('KWD', 3, 'KWD', 'KW', 'Kuwait',               'Kuwaiti dinar'),
    ('BHD', 3, 'BHD', 'BH', 'Bahrain',              'Bahraini dinar'),

    # Large economies and widely held currencies.
    ('INR', 2, '₹',   'IN', 'India',        'Indian rupee'),
    ('KRW', 0, '₩',   'KR', 'South Korea',  'South Korean won'),
    ('TRY', 2, '₺',   'TR', 'Türkiye',      'Turkish lira'),
    ('RUB', 2, '₽',   'RU', 'Russia',       'Russian ruble'),
    ('BRL', 2, 'R$',  'BR', 'Brazil',       'Brazilian real'),
    ('MXN', 2, '$',   'MX', 'Mexico',       'Mexican peso'),
    ('ZAR', 2, 'R',   'ZA', 'South Africa', 'South African rand'),
    ('SEK', 2, 'kr',  'SE', 'Sweden',       'Swedish krona'),
    ('NOK', 2, 'kr',  'NO', 'Norway',       'Norwegian krone'),
    ('DKK', 2, 'kr',  'DK', 'Denmark',      'Danish krone'),
    ('PLN', 2, 'zł',  'PL', 'Poland',       'Polish złoty'),
    ('NZD', 2, '$',   'NZ', 'New Zealand',  'New Zealand dollar'),
    ('THB', 2, '฿',   'TH', 'Thailand',     'Thai baht'),
    ('IDR', 2, 'Rp',  'ID', 'Indonesia',    'Indonesian rupiah'),
    ('MYR', 2, 'RM',  'MY', 'Malaysia',     'Malaysian ringgit'),
    ('PHP', 2, '₱',   'PH', 'Philippines',  'Philippine peso'),
    ('TWD', 2, r'NT$','TW', 'Taiwan',       'New Taiwan dollar'),
    ('ILS', 2, '₪',   'IL', 'Israel',       'Israeli new shekel'),
    ('CZK', 2, 'Kč',  'CZ', 'Czechia',      'Czech koruna'),
    ('HUF', 2, 'Ft',  'HU', 'Hungary',      'Hungarian forint'),
    ('RON', 2, 'lei', 'RO', 'Romania',      'Romanian leu'),
    ('VND', 0, '₫',   'VN', 'Vietnam',      'Vietnamese dong'),

    # Rest of Asia.
    ('PKR', 2, 'PKR', 'PK', 'Pakistan',    'Pakistani rupee'),
    ('BDT', 2, '৳',   'BD', 'Bangladesh',  'Bangladeshi taka'),
    ('LKR', 2, 'LKR', 'LK', 'Sri Lanka',   'Sri Lankan rupee'),
    ('NPR', 2, 'NPR', 'NP', 'Nepal',       'Nepalese rupee'),
    ('AFN', 2, '؋',   'AF', 'Afghanistan', 'Afghan afghani'),
    ('MMK', 2, 'K',   'MM', 'Myanmar',     'Burmese kyat'),
    ('KHR', 2, '៛',   'KH', 'Cambodia',    'Cambodian riel'),
    ('LAK', 2, '₭',   'LA', 'Laos',        'Lao kip'),
    ('BND', 2, '$',   'BN', 'Brunei',      'Brunei dollar'),
    ('MOP', 2, 'MOP', 'MO', 'Macau',       'Macanese pataca'),
    ('MNT', 2, '₮',   'MN', 'Mongolia',    'Mongolian tugrik'),
    ('MVR', 2, 'MVR', 'MV', 'Maldives',    'Maldivian rufiyaa'),
    ('BTN', 2, 'BTN', 'BT', 'Bhutan',      'Bhutanese ngultrum'),

    # Caucasus and Central Asia.
    ('KZT', 2, '₸',   'KZ', 'Kazakhstan',   'Kazakhstani tenge'),
    ('UZS', 2, 'UZS', 'UZ', 'Uzbekistan',   'Uzbekistani som'),
    ('AZN', 2, '₼',   'AZ', 'Azerbaijan',   'Azerbaijani manat'),
    ('GEL', 2, '₾',   'GE', 'Georgia',      'Georgian lari'),
    ('AMD', 2, '֏',   'AM', 'Armenia',      'Armenian dram'),
    ('TJS', 2, 'TJS', 'TJ', 'Tajikistan',   'Tajikistani somoni'),
    ('TMT', 2, 'TMT', 'TM', 'Turkmenistan', 'Turkmenistan manat'),
    ('KGS', 2, 'KGS', 'KG', 'Kyrgyzstan',   'Kyrgyzstani som'),

    # Rest of the Middle East and North Africa.
    ('IQD', 3, 'IQD', 'IQ', 'Iraq',    'Iraqi dinar'),
    ('JOD', 3, 'JOD', 'JO', 'Jordan',  'Jordanian dinar'),
    ('LBP', 2, 'LBP', 'LB', 'Lebanon', 'Lebanese pound'),
    ('SYP', 2, 'SYP', 'SY', 'Syria',   'Syrian pound'),
    ('YER', 2, 'YER', 'YE', 'Yemen',   'Yemeni rial'),
    ('EGP', 2, 'EGP', 'EG', 'Egypt',   'Egyptian pound'),
    ('MAD', 2, 'MAD', 'MA', 'Morocco', 'Moroccan dirham'),
    ('DZD', 2, 'DZD', 'DZ', 'Algeria', 'Algerian dinar'),
    ('TND', 3, 'TND', 'TN', 'Tunisia', 'Tunisian dinar'),
    ('LYD', 3, 'LYD', 'LY', 'Libya',   'Libyan dinar'),

    # Rest of Europe.
    ('ISK', 0, 'kr',  'IS', 'Iceland',            'Icelandic króna'),
    ('BGN', 2, 'лв',  'BG', 'Bulgaria',           'Bulgarian lev'),
    ('RSD', 2, 'RSD', 'RS', 'Serbia',             'Serbian dinar'),
    ('UAH', 2, '₴',   'UA', 'Ukraine',            'Ukrainian hryvnia'),
    ('BYN', 2, 'Br',  'BY', 'Belarus',            'Belarusian ruble'),
    ('MDL', 2, 'MDL', 'MD', 'Moldova',            'Moldovan leu'),
    ('ALL', 2, 'L',   'AL', 'Albania',            'Albanian lek'),
    ('MKD', 2, 'MKD', 'MK', 'North Macedonia',    'Macedonian denar'),
    ('BAM', 2, 'KM',  'BA', 'Bosnia and Herzegovina', 'Convertible mark'),
    ('GIP', 2, '£',   'GI', 'Gibraltar',          'Gibraltar pound'),

    # The Americas.
    ('ARS', 2, '$',   'AR', 'Argentina',          'Argentine peso'),
    ('CLP', 0, '$',   'CL', 'Chile',              'Chilean peso'),
    ('COP', 2, '$',   'CO', 'Colombia',           'Colombian peso'),
    ('PEN', 2, 'S/',  'PE', 'Peru',               'Peruvian sol'),
    ('UYU', 2, '$',   'UY', 'Uruguay',            'Uruguayan peso'),
    ('PYG', 0, '₲',   'PY', 'Paraguay',           'Paraguayan guarani'),
    ('BOB', 2, 'Bs',  'BO', 'Bolivia',            'Bolivian boliviano'),
    ('VES', 2, 'Bs',  'VE', 'Venezuela',          'Venezuelan bolívar'),
    ('GTQ', 2, 'Q',   'GT', 'Guatemala',          'Guatemalan quetzal'),
    ('HNL', 2, 'L',   'HN', 'Honduras',           'Honduran lempira'),
    ('NIO', 2, r'C$', 'NI', 'Nicaragua',          'Nicaraguan córdoba'),
    ('CRC', 2, '₡',   'CR', 'Costa Rica',         'Costa Rican colón'),
    ('PAB', 2, 'B/',  'PA', 'Panama',             'Panamanian balboa'),
    ('DOP', 2, r'RD$','DO', 'Dominican Republic', 'Dominican peso'),
    ('CUP', 2, '$',   'CU', 'Cuba',               'Cuban peso'),
    ('JMD', 2, '$',   'JM', 'Jamaica',            'Jamaican dollar'),
    ('TTD', 2, '$',   'TT', 'Trinidad and Tobago','Trinidad and Tobago dollar'),
    ('BBD', 2, '$',   'BB', 'Barbados',           'Barbadian dollar'),
    ('BSD', 2, '$',   'BS', 'Bahamas',            'Bahamian dollar'),
    ('BZD', 2, '$',   'BZ', 'Belize',             'Belize dollar'),
    ('XCD', 2, '$',   'AG', 'Eastern Caribbean',  'East Caribbean dollar'),
    ('HTG', 2, 'G',   'HT', 'Haiti',              'Haitian gourde'),
    ('SRD', 2, '$',   'SR', 'Suriname',           'Surinamese dollar'),
    ('GYD', 2, '$',   'GY', 'Guyana',             'Guyanese dollar'),
    ('ANG', 2, 'ƒ',   'CW', 'Curaçao',            'Netherlands Antillean guilder'),
    ('AWG', 2, 'ƒ',   'AW', 'Aruba',              'Aruban florin'),
    ('KYD', 2, '$',   'KY', 'Cayman Islands',     'Cayman Islands dollar'),
    ('BMD', 2, '$',   'BM', 'Bermuda',            'Bermudian dollar'),

    # Sub-Saharan Africa.
    ('NGN', 2, '₦',   'NG', 'Nigeria',      'Nigerian naira'),
    ('GHS', 2, '₵',   'GH', 'Ghana',        'Ghanaian cedi'),
    ('KES', 2, 'KSh', 'KE', 'Kenya',        'Kenyan shilling'),
    ('TZS', 2, 'TSh', 'TZ', 'Tanzania',     'Tanzanian shilling'),
    ('UGX', 0, 'USh', 'UG', 'Uganda',       'Ugandan shilling'),
    ('ETB', 2, 'ETB', 'ET', 'Ethiopia',     'Ethiopian birr'),
    ('SDG', 2, 'SDG', 'SD', 'Sudan',        'Sudanese pound'),
    ('SSP', 2, 'SSP', 'SS', 'South Sudan',  'South Sudanese pound'),
    ('SOS', 2, 'SOS', 'SO', 'Somalia',      'Somali shilling'),
    ('ERN', 2, 'ERN', 'ER', 'Eritrea',      'Eritrean nakfa'),
    ('DJF', 0, 'DJF', 'DJ', 'Djibouti',     'Djiboutian franc'),
    ('RWF', 0, 'RWF', 'RW', 'Rwanda',       'Rwandan franc'),
    ('BIF', 0, 'BIF', 'BI', 'Burundi',      'Burundian franc'),
    ('XOF', 0, 'XOF', 'SN', 'West Africa',  'West African CFA franc'),
    ('XAF', 0, 'XAF', 'CM', 'Central Africa','Central African CFA franc'),
    ('ZMW', 2, 'ZK',  'ZM', 'Zambia',       'Zambian kwacha'),
    ('MWK', 2, 'MK',  'MW', 'Malawi',       'Malawian kwacha'),
    ('MZN', 2, 'MT',  'MZ', 'Mozambique',   'Mozambican metical'),
    ('AOA', 2, 'Kz',  'AO', 'Angola',       'Angolan kwanza'),
    ('BWP', 2, 'P',   'BW', 'Botswana',     'Botswana pula'),
    ('NAD', 2, '$',   'NA', 'Namibia',      'Namibian dollar'),
    ('SZL', 2, 'E',   'SZ', 'Eswatini',     'Swazi lilangeni'),
    ('LSL', 2, 'L',   'LS', 'Lesotho',      'Lesotho loti'),
    ('MUR', 2, 'MUR', 'MU', 'Mauritius',    'Mauritian rupee'),
    ('SCR', 2, 'SCR', 'SC', 'Seychelles',   'Seychellois rupee'),
    ('MGA', 2, 'MGA', 'MG', 'Madagascar',   'Malagasy ariary'),
    ('KMF', 0, 'KMF', 'KM', 'Comoros',      'Comorian franc'),
    ('CVE', 2, 'CVE', 'CV', 'Cabo Verde',   'Cape Verdean escudo'),
    ('STN', 2, 'STN', 'ST', 'São Tomé and Príncipe', 'São Tomé and Príncipe dobra'),
    ('GMD', 2, 'GMD', 'GM', 'Gambia',       'Gambian dalasi'),
    ('GNF', 0, 'GNF', 'GN', 'Guinea',       'Guinean franc'),
    ('SLE', 2, 'SLE', 'SL', 'Sierra Leone', 'Sierra Leonean leone'),
    ('LRD', 2, '$',   'LR', 'Liberia',      'Liberian dollar'),
    ('MRU', 2, 'MRU', 'MR', 'Mauritania',   'Mauritanian ouguiya'),

    # The Pacific.
    ('FJD', 2, '$',   'FJ', 'Fiji',             'Fijian dollar'),
    ('PGK', 2, 'K',   'PG', 'Papua New Guinea', 'Papua New Guinean kina'),
    ('SBD', 2, '$',   'SB', 'Solomon Islands',  'Solomon Islands dollar'),
    ('WST', 2, 'WST', 'WS', 'Samoa',            'Samoan tala'),
    ('TOP', 2, 'TOP', 'TO', 'Tonga',            'Tongan paʻanga'),
    ('VUV', 0, 'VUV', 'VU', 'Vanuatu',          'Vanuatu vatu'),
    ('XPF', 0, 'XPF', 'PF', 'French Pacific',   'CFP franc'),
]

# The ISO 4217 exponents that are not 2. Written out so the table can be
# checked against it rather than trusted.
ZERO_DECIMAL = {
    'BIF', 'CLP', 'DJF', 'GNF', 'ISK', 'JPY', 'KMF', 'KRW', 'PYG', 'RWF',
    'UGX', 'VND', 'VUV', 'XAF', 'XOF', 'XPF',
}
THREE_DECIMAL = {'BHD', 'IQD', 'JOD', 'KWD', 'LYD', 'OMR', 'TND'}
# Deliberate departures from ISO 4217, with the reason at the row above.
EXCEPTIONS = {'IRR': 0}
