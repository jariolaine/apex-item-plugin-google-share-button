set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,23586211258544398));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,300);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/org_blogsite_jaris_google_share_button
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 58228149654207554 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'ORG.BLOGSITE.JARIS.GOOGLE_SHARE_BUTTON'
 ,p_display_name => 'Google Share Button'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'function render_google_share_button ('||unistr('\000a')||
'	p_item					in apex_plugin.t_page_item,'||unistr('\000a')||
'	p_plugin				in apex_plugin.t_plugin,'||unistr('\000a')||
'	p_value					in varchar2,'||unistr('\000a')||
'	p_is_readonly			in boolean,'||unistr('\000a')||
'	p_is_printer_friendly	in boolean'||unistr('\000a')||
') return apex_plugin.t_page_item_render_result'||unistr('\000a')||
'as'||unistr('\000a')||
'c_host constant varchar2(4000) := apex_util.host_url(''SCRIPT'');'||unistr('\000a')||
''||unistr('\000a')||
'l_url			varchar2(4000);'||unistr('\000a')||
'l_page_url		varchar2(4000)	:= p_item.attribute_02;'||unistr('\000a')||
'l_cus'||
'tom_url	varchar2(4000)	:= p_item.attribute_03;'||unistr('\000a')||
'l_url_to_share	varchar2(20)	:= coalesce(p_item.attribute_01, ''current_page'');'||unistr('\000a')||
'l_annotation	varchar2(20)	:= coalesce(p_item.attribute_04, ''bubble'');'||unistr('\000a')||
'l_width			varchar2(256)	:= p_item.attribute_05;'||unistr('\000a')||
'l_height		varchar2(256)	:= coalesce(p_item.attribute_06, ''20'');'||unistr('\000a')||
'l_align			varchar2(20)	:= coalesce(p_item.attribute_07, ''left'');'||unistr('\000a')||
'l_expandto		varchar2(100)	:='||
' p_item.attribute_08;'||unistr('\000a')||
'l_result		apex_plugin.t_page_item_render_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
'	-- don''t show the widget if we are running in printer friendly mode'||unistr('\000a')||
'	if p_is_printer_friendly then'||unistr('\000a')||
'		return null;'||unistr('\000a')||
'	end if;'||unistr('\000a')||
''||unistr('\000a')||
'	-- Generate the Google Share based on our URL setting.'||unistr('\000a')||
'	-- Note: Always use session 0, otherwise Google Share will always register a different URL.'||unistr('\000a')||
'	l_url := case l_url_to_share'||unistr('\000a')||
'				when ''current_p'||
'age'' then'||unistr('\000a')||
'					c_host || ''f?p='' || apex_application.g_flow_id || '':'' || apex_application.g_flow_step_id || '':0'''||unistr('\000a')||
'				when ''page_url'' then'||unistr('\000a')||
'					c_host || l_page_url'||unistr('\000a')||
'				when ''custom_url'' then'||unistr('\000a')||
'					replace(l_custom_url, ''#HOST#'', c_host)'||unistr('\000a')||
'				when ''value'' then'||unistr('\000a')||
'					replace(p_value, ''#HOST#'', c_host)'||unistr('\000a')||
'				end;'||unistr('\000a')||
'	-- Output the Google Share button widget'||unistr('\000a')||
'	-- See https://developers.google.com/+/web/share/ f'||
'or syntax'||unistr('\000a')||
'	sys.htp.prn ('||unistr('\000a')||
'			''<div class="g-plus" data-action="share"'''||unistr('\000a')||
'		||	'' data-href="'' || apex_escape.html_attribute(l_url) || ''"'''||unistr('\000a')||
'		||	'' data-annotation="'' || apex_escape.html_attribute(l_annotation) || ''"'''||unistr('\000a')||
'		||	'' data-width="'' || apex_escape.html_attribute(l_annotation) || ''"'''||unistr('\000a')||
'		||	'' data-height="'' || apex_escape.html_attribute(l_height) || ''"'''||unistr('\000a')||
'		||	'' data-align="'' || apex_escape.html_attribu'||
'te(l_align) || ''"'''||unistr('\000a')||
'		||	'' data-expandTo="'' || apex_escape.html_attribute(replace(l_expandto, '':'', '','')) || ''"'''||unistr('\000a')||
'		||	''></div>'''||unistr('\000a')||
'	);'||unistr('\000a')||
'	apex_javascript.add_library('||unistr('\000a')||
'		p_name		=> ''platform'','||unistr('\000a')||
'		p_directory	=> ''https://apis.google.com/js/'','||unistr('\000a')||
'		p_key		=> ''com.google.apis.platform'''||unistr('\000a')||
'	);'||unistr('\000a')||
'	-- Tell APEX that this field is NOT navigable'||unistr('\000a')||
'	l_result.is_navigable := false;'||unistr('\000a')||
'	return l_result;'||unistr('\000a')||
'end render_google_share_bu'||
'tton;'
 ,p_render_function => 'render_google_share_button'
 ,p_standard_attributes => 'VISIBLE:SOURCE:ELEMENT'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_help_text => '<p>'||unistr('\000a')||
'	Google+ share button widget based on the definition at <a href="https://developers.google.com/+/web/share/" target="_blank">https://developers.google.com/+/web/share/</a></p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	Add this button to content across your pages to make sharing on Google+ easy. This button is perfect for content that users may want to share but not +1 (e.g. news or controversial content).</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	Use of the Google+ Share Button code is subject to the <a href="https://developers.google.com/+/web/buttons-policy" target="_blank">Google Button Publisher Policies</a>.</p>'||unistr('\000a')||
''
 ,p_version_identifier => '1.0'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 58228544682225061 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 58228149654207554 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'URL to Google+'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'current_page'
 ,p_is_translatable => false
 ,p_help_text => 'Suggest a default URL which will be included in the Google+ share button.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58228940584226976 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58228544682225061 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Current Page'
 ,p_return_value => 'current_page'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58229337349228483 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58228544682225061 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Page URL'
 ,p_return_value => 'page_url'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58229734115229937 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58228544682225061 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Custom URL'
 ,p_return_value => 'custom_url'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58230130880231437 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58228544682225061 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Value of Page Item'
 ,p_return_value => 'value'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 58231025260249219 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 58228149654207554 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Page URL'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_display_length => 50
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 58228544682225061 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'page_url'
 ,p_help_text => '<p>Enter a page URL in the Oracle APEX <code>f?p=</code> syntax. See <a href="http://download.oracle.com/docs/cd/E17556_01/doc/user.40/e15517/concept.htm#BEIFCDGF" target="_blank">Understanding URL syntax</a> in the Oracle APEX online documentation.</p>'||unistr('\000a')||
''||unistr('\000a')||
'<p><strong>Note:</strong> You can only reference public pages and you have to use <strong>0</strong> as session id, otherwise the URL will not be identified as the same URL. It''s also not allowed to end the page URL with a colon.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 58231537540258713 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 58228149654207554 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Custom URL'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => 'http://'
 ,p_display_length => 50
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 58228544682225061 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'custom_url'
 ,p_help_text => 'Enter the URL which should be included in the Google+ share button.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 58234046573284975 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 58228149654207554 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Annotation'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'bubble'
 ,p_is_translatable => false
 ,p_help_text => 'The annotation to display next to the button.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
''||unistr('\000a')||
'<strong>inline</strong> : Display profile pictures of connected users who have shared the page and a count of users who have shared the page.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'<strong>Bubble</strong> : Display the number of users who have shared the page in a graphic next to the button.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'<strong>vertical-bubble</strong> : Display the number of users who have shared the page in a graphic above the button.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'<strong>none</strong> : Do not render any additional annotations. '
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58234345279285537 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58234046573284975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Inline'
 ,p_return_value => 'inline'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58234742260286939 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58234046573284975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Bubble'
 ,p_return_value => 'bubble'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 41100345713877661 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58234046573284975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Vertical Bubble'
 ,p_return_value => 'vertical-bubble'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58235140966287506 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58234046573284975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'None'
 ,p_return_value => 'none'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 58236126708324531 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 58228149654207554 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Width'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_display_length => 10
 ,p_is_translatable => false
 ,p_help_text => 'The maximum width to allocate to the entire share plugin. See <a href="https://developers.google.com/+/web/share/#button-sizes" target="_blank">Button Sizes</a> for more information. '
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 41101246551907575 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 58228149654207554 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Height'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => false
 ,p_default_value => '20'
 ,p_display_length => 10
 ,p_is_translatable => false
 ,p_help_text => 'The height to assign the button. This may be 15, 20, 24 or 60. See < href="https://developers.google.com/+/web/share/#button-sizes" target="_blank"<Button Sizes</a> for more information. '
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 41101929729915409 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 41101246551907575 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => '15'
 ,p_return_value => '15'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 41102328651915877 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 41101246551907575 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => '20'
 ,p_return_value => '20'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 41102726926916684 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 41101246551907575 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => '24'
 ,p_return_value => '24'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 41103125632917300 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 41101246551907575 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => '60'
 ,p_return_value => '60'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 58236448909329441 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 58228149654207554 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Align'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'left'
 ,p_is_translatable => false
 ,p_help_text => 'Sets the alignment of the button assets within its frame.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58236747183330234 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58236448909329441 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Right'
 ,p_return_value => 'right'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58237145242331099 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58236448909329441 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Left'
 ,p_return_value => 'left'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 58237523461341190 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 58228149654207554 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Expand to'
 ,p_attribute_type => 'CHECKBOXES'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_help_text => 'Sets the preferred positions to display hover and confirmation bubbles, which are relative to the button. Set this parameter when your page contains certain elements, such as Flash objects, that might interfere with rendering the bubbles.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'For example, <strong>top</strong> will display the hover and confirmation bubbles above the button.<br/>'||unistr('\000a')||
'<br/>'||unistr('\000a')||
'If omitted, the rendering logic will guess the best position, usually defaulting to below the button by using the <strong>bottom</strong> value. '
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58237854288342092 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58237523461341190 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Top'
 ,p_return_value => 'top'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58238252347342994 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58237523461341190 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Right'
 ,p_return_value => 'right'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58238651053343672 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58237523461341190 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Bottom'
 ,p_return_value => 'bottom'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 58239049759344270 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 58237523461341190 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Left'
 ,p_return_value => 'left'
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
