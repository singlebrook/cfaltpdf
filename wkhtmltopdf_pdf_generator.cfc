<cfcomponent extends="base_pdf_generator">

<!--- generate a PDF and push it to the output stream --->
<cffunction name="generate" returntype="void" output="true" access="public">
	<cfset var outFile = generateFile()>
	<cfcontent type="application/pdf" reset="true" file="#outFile#">
</cffunction>

<!--- generate a PDF in a tmp file and return the full path to the file --->
<cffunction name="generateFile" returntype="string" output="false" access="public">
	<cfset var execArgs = baseExecArgs()>

	<cfif StructKeyExists(variables, 'headerHTML')>
		<cfset var headerFile = uniqueTempFile()>
		<cfset FileWrite(headerFile, getHeader())>
		<cfset ArrayAppend(execArgs, '--header-html #headerFile#')>
	</cfif>
	<cfif StructKeyExists(variables, 'footerHTML')>
		<cfset var footerFile = uniqueTempFile()>
		<cfset FileWrite(footerFile, getFooter())>
		<cfset ArrayAppend(execArgs, '--footer-html #footerFile#')>
	</cfif>

	<cfset var bodyFile = uniqueTempFile()>
	<cfset FileWrite(bodyFile, ArrayToList(variables.body_parts, ' '))>
	<cfset ArrayAppend(execArgs, bodyFile)>

	<cfset var outFile = uniqueTempFile('pdf')>
	<cfset ArrayAppend(execArgs, outFile)>

	<cfexecute name="/usr/local/bin/wkhtmltopdf" arguments="#ArrayToList(execArgs, ' ')#" timeout="#variables.executeTimeout#"></cfexecute>
	<cfreturn outFile>
</cffunction>

<cfscript>

private array function baseExecArgs(){
	var args = [ '--page-size #variables.pagetype#'
		, '--orientation #variables.orientation#' ];
	for( var key in variables.margins ){
		ArrayAppend(args, '--margin-#key# #variables.margins[key]#');
	}
	for( var key in variables.addlOptions ){
		ArrayAppend(args, '--#key# #variables.addlOptions[key]#');
	}
	return args;
}

private struct function documentVariableMapping(){
	/* The javascript here is an adaptation of some code in "Footers And Headers"
		https://github.com/antialize/wkhtmltopdf/blob/master/README_WKHTMLTOPDF#L312-L332

		The replacement values are in the query string for the document */
	return { '$currentPageNumber$' = '<script>document.write(("&" + document.location.search.substring(1) ).split("&page=")[1].split("&")[0]);</script>'
		,	'$totalPageCount$' = '<script>document.write(("&" + document.location.search.substring(1) ).split("topage=")[1].split("&")[0]);</script>'};
}

private string function uniqueTempFile(string ext = 'html'){
	return GetTempDirectory() & 'pdfGen' & Replace(CreateUUID(), '-', '', 'all') & '.' & arguments.ext;
}

</cfscript>

</cfcomponent>
