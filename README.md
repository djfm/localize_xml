#localize_xml#

This tool enables you to give XML files to translate to non-tech people.

It takes a CSV file with 2 columns, file and xpath, describing what should be extracted from the XML files, and a folder in which it looks for said files.

Here is a sample CSV file designed to extract data from the PrestaShop installer XML files:

```
file,xpath
contact.xml,//contact/@name
contact.xml,//contact/description
carrier.xml,//carrier/delay
category.xml,//category/name
category.xml,//category/link_rewrite
cms.xml,//cms/meta_title
cms.xml,//cms/meta_description
cms.xml,//cms/content
cms.xml,//cms/link_rewrite
cms_category.xml,//cms_category/name
cms_category.xml,//cms_category/link_rewrite
configuration.xml,//configuration/value
gender.xml,//gender/@name
group.xml,//group/@name
meta.xml,//meta/title
meta.xml,//meta/description
meta.xml,//meta/url_rewrite
order_return_state.xml,//order_return_state/name
order_state.xml,//order_state/name
profile.xml,//profile/name
quick_access.xml,//quick_access/@name
risk.xml,//risk/@name
stock_mvt_reason.xml,//stock_mvt_reason/name
supplier_order_state.xml,//supplier_order_state/name
supply_order_state.xml,//supply_order_state/name
```

A line like
```
group.xml,//group/@name
```
means: extract all attributes from nodes named group in the file named group.xml

Specify only one xpath per line. You can have as many lines as you want per file.

#Dependencies#

A few ruby gems are necessary.

```
gem install writeexcel spreadsheet
```

If your ruby version does not include them by default, also install csv and rexml.

#Usage#

```bash
extract_xml_translatable_strings.rb path/to/template.csv  path/to/dir/containing/xml/files [path/to/output/file]
```

This will build a file called translatable_strings.xlsx in the current directory unless you specified some other name.

Send this file to a translator! Tell him not to touch anything other than the translation column and he should be unable to mess your XML file up, hard though he may try.


Once the file comes back, integrate it like this:

```bash
integrate_xml_translatable_strings.rb path/to/translatable_strings.xlsx path/to/dir/containing/xml/files
```

Your xml files are now exactly the same as before BUT with all translatable contents replaced with the translation!
