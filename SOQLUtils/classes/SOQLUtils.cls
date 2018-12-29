public with sharing class SOQLUtils {
	
	/**
	 * getQuery Returns something like Select * FROM
	 * @param  sObjectName       The SObject name
	 * @param  includeReferences Tells if the method should also return lookup or master-detail fields
	 * @param  updateatableOnly  Tells if the method should return only updateatable fields
	 * @return                   return The query
	 */
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