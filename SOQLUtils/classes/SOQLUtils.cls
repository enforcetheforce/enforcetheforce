public with sharing class SOQLUtils {

	public static String getQuery( String sObjectName, Boolean includeReferences, Boolean updateatableOnly ) {
		String query = 'Select ';
		Map<String,String> sObjectFields = SchemaUtils.getFields( sObjectName, includeReferences, updateatableOnly );
		for( String fieldName : sObjectFields.keySet() ) {
			query += fieldName + ', ';
		}

		query = query.left( query.length() - 1 );
		query += ' from ' + sObjectName;
		return query;
	}

}