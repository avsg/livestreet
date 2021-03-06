<!doctype html>

<!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="ru"> <![endif]-->
<!--[if IE 7]>    <html class="no-js ie7 oldie" lang="ru"> <![endif]-->
<!--[if IE 8]>    <html class="no-js ie8 oldie" lang="ru"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="ru"> <!--<![endif]-->

<head>
	{hook run='html_head_begin'}

	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

	<title>{$sHtmlTitle}</title>

	<meta name="description" content="{$sHtmlDescription}">
	<meta name="keywords" content="{$sHtmlKeywords}">

	{**
	 * Стили
	 * CSS файлы подключаются в конфиге шаблона (your_skin/settings/config.php)
	 *}
	{$aHtmlHeadFiles.css}

	<link href="{cfg name='path.static.skin'}/images/favicon.ico?v1" rel="shortcut icon" />
	<link rel="search" type="application/opensearchdescription+xml" href="{router page='search'}opensearch/" title="{cfg name='view.name'}" />

	{**
	 * RSS
	 *}
	{if $aHtmlRssAlternate}
		<link rel="alternate" type="application/rss+xml" href="{$aHtmlRssAlternate.url}" title="{$aHtmlRssAlternate.title}">
	{/if}

	{if $sHtmlCanonical}
		<link rel="canonical" href="{$sHtmlCanonical}" />
	{/if}

	{if $bRefreshToHome}
		<meta  HTTP-EQUIV="Refresh" CONTENT="3; URL={cfg name='path.root.web'}/">
	{/if}


	<script>
		var DIR_WEB_ROOT 			= '{cfg name="path.root.web"}',
			DIR_STATIC_SKIN 		= '{cfg name="path.static.skin"}',
			DIR_STATIC_FRAMEWORK 	= '{cfg name="path.static.framework"}',
			LIVESTREET_SECURITY_KEY = '{$LIVESTREET_SECURITY_KEY}',
			SESSION_ID				= '{$_sPhpSessionId}',
			LANGUAGE				= '{$oConfig->GetValue('lang.current')}',
			WYSIWIG					= {if $oConfig->GetValue('view.wysiwyg')}true{else}false{/if};

		var aRouter = [];
		{foreach from=$aRouter key=sPage item=sPath}
			aRouter['{$sPage}'] = '{$sPath}';
		{/foreach}
	</script>

	{**
	 * JavaScript файлы
	 * JS файлы подключаются в конфиге шаблона (your_skin/settings/config.php)
	 *}
	{$aHtmlHeadFiles.js}

	<script>
		ls.lang.load({json var = $aLangJs});
		ls.lang.load({lang_load name="blog"});

		ls.registry.set('comment_max_tree', {json var=$oConfig->Get('module.comment.max_tree')});
		ls.registry.set('block_stream_show_tip', {json var=$oConfig->Get('block.stream.show_tip')});
	</script>


	{if {cfg name='view.grid.type'} == 'fluid'}
		<style>
			#container {
				min-width: {cfg name='view.grid.fluid_min_width'}px;
				max-width: {cfg name='view.grid.fluid_max_width'}px;
			}
		</style>
	{else}
		<style>
			#container { width: {cfg name='view.grid.fixed_width'}px; }
		</style>
	{/if}


	{hook run='html_head_end'}
</head>


{**
 * Вспомогательные классы
 *}
{if $oUserCurrent}
	{assign var=body_classes value=$body_classes|cat:' ls-user-role-user'}

	{if $oUserCurrent->isAdministrator()}
		{assign var=body_classes value=$body_classes|cat:' ls-user-role-admin'}
	{/if}
{else}
	{assign var=body_classes value=$body_classes|cat:' ls-user-role-guest'}
{/if}

{if !$oUserCurrent or ($oUserCurrent and !$oUserCurrent->isAdministrator())}
	{assign var=body_classes value=$body_classes|cat:' ls-user-role-not-admin'}
{/if}

{assign var=body_classes value=$body_classes|cat:' ls-template-'|cat:{cfg name="view.skin"}}


{**
 * Добавление кнопок в тулбар
 *}
{add_block group='toolbar' name='toolbar/toolbar_admin.tpl' priority=100}
{add_block group='toolbar' name='toolbar/toolbar_scrollup.tpl' priority=-100}


<body class="{$body_classes} width-{cfg name='view.grid.type'}">
	{hook run='body_begin'}
	
	{if $oUserCurrent}
		{include file='modals/modal.write.tpl'}
		{include file='modals/modal.favourite_form_tags.tpl'}
	{else}
		{include file='modals/modal.login.tpl'}
	{/if}
	
	<div id="header-back"></div>
	
	<div id="container" class="{hook run='container_class'}">
		{include file='header_top.tpl'}
		{include file='navs/nav.tpl'}

		<div id="wrapper" class="{if $noSidebar}no-sidebar{/if}{hook run='wrapper_class'}">
			<div id="content-wrapper">
				<div id="content" role="main" {if $sMenuItemSelect=='profile'}itemscope itemtype="http://data-vocabulary.org/Person"{/if}>
					{include file='navs/nav_content.tpl'}
					{include file='system_message.tpl'}
					
					{hook run='content_begin'}