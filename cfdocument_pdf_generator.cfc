<cfcomponent extends="base_pdf_generator">

<cfscript>
public void function appendPageBreakToBody(){
	ArrayAppend(variables.body_parts, '<pagebreak>');
}
</cfscript>

<cffunction name="generate" returntype="void" output="true" access="public">
	<cfdocument attributeCollection="#cfDocAttrs()#">
		<cfif StructKeyExists(variables, 'headerHTML')>
			<cfdocumentitem type="header">
				#getHeader()#
			</cfdocumentitem>
		</cfif>
		<cfif StructKeyExists(variables, 'footerHTML')>
			<cfdocumentitem type="footer">
				#getFooter()#
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

private struct function documentVariableMapping(){
	return { '$currentPageNumber$' = cfdocument.currentpagenumber
		,	'$totalPageCount$' = cfdocument.totalpagecount };
}

</cfscript>

</cfcomponent>
