<cfcomponent extends="base_pdf_generator">

<cffunction name="generatePDF" returntype="void" output="true" access="public">
	<cfdocument attributeCollection="#cfDocAttrs()#">
		<cfif StructKeyExists(variables, 'headerHTML')>
			<cfdocumentitem type="header">
				#replaceDocumentVars(variables.headerHTML)#
			</cfdocumentitem>
		</cfif>
		<cfif StructKeyExists(variables, 'footerHTML')>
			<cfdocumentitem type="footer">
				#replaceDocumentVars(variables.footerHTML)#
			</cfdocumentitem>
		</cfif>

		<cfloop array="#variables.body_parts#" index="local.part">
			<cfif part EQ '<pagebreak>'>
				<cfdocumentitem type="pagebreak" />
			<cfelse>
				#part#
			</cfif>
		</cfloop>
	</cfdocument>
</cffunction>

<cfscript>

private struct function cfDocAttrs(){
	var attrs = { format = 'pdf'
		, pagetype = variables.pagetype
		, orientation = variables.orientation };
	for( var key in variables.margins ){
		attrs['margin#key#'] = variables.margins[key];
	}
	return attrs;
}

private string function replaceDocumentVars(required string html){
	return ReplaceNoCase(ReplaceNoCase(
			arguments.html
			, '$currentPageNumber$'
			, cfdocument.currentpagenumber
		), '$totalPageCount$'
		, cfdocument.totalpagecount
	);
}

</cfscript>

</cfcomponent>
