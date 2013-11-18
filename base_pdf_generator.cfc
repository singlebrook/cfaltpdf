component {

public component function init(string orientation = 'portrait'
		, struct margins = {}
		, string pageType = 'letter'){

	variables.body_parts = [];

	for( var key in ['orientation', 'margins', 'pageType'] ){
		variables[key] = arguments[key];
	}

	return this;
}

public void function appendToBody(required string html){
	ArrayAppend(variables.body_parts, arguments.html);
}

public void function generatePDF(){
	//PDF Generation
}

public void function setHeader(required string headerHTML){
	variables.headerHTML = arguments.headerHTML;

}

public void function setFooter(required string footerHTML){
	variables.footerHTML = arguments.footerHTML;
}

private string function replaceDocumentVars(required string html){
	/* Variables that should be dealt with:
		$currentPageNumber$
		$totalPageCount$
	*/
	throw(type="unimplementedFunction"
		message="This function needs to be implemented by children classes");
}

}