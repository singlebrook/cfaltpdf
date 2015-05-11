component {

public component function init(string orientation = 'Portrait'
		, struct margins = {}
		, string pageType = 'Letter'
		, numeric executeTimeout = 30
		, struct addlOptions = {}){

	variables.body_parts = [];

	for( var key in ['orientation', 'margins', 'pageType', 'executeTimeout', 'addlOptions'] ){
		variables[key] = arguments[key];
	}

	return this;
}

public void function appendPageBreakToBody(){
	ArrayAppend(variables.body_parts, '<div style="page-break-after:always; display: block; clear: both;"></div>');
}

public void function appendToBody(required string html){
	ArrayAppend(variables.body_parts, cleanHTML(arguments.html));
}

public void function generate(){
	//PDF Generation
}

public void function setHeader(required string headerHTML){
	variables.headerHTML = arguments.headerHTML;

}

public void function setFooter(required string footerHTML){
	variables.footerHTML = arguments.footerHTML;
}

private string function cleanHTML(required string html){
	var clean = Replace(arguments.html, '†', '&dagger;', 'all');
	return clean;
}

private string function getFooter(){
	return replaceDocumentVars(variables.footerHTML);
}

private string function getHeader(){
	return replaceDocumentVars(variables.headerHTML);
}

private string function replaceDocumentVars(required string html){
	var htmlInProgress = arguments.html;
	var varMap = documentVariableMapping();
	for( var key in varMap ){
		htmlInProgress = ReplaceNoCase(htmlInProgress, key, varMap[key], 'all');
	}

	return htmlInProgress;
}

private struct function documentVariableMapping(){
	/*
	return { '$currentPageNumber$' = '[page]'
		,	'$totalPageCount$' = '[topage]'};
	*/
	throw(type="unimplementedFunction",
		message="This function needs to be implemented by children classes");
}

}
