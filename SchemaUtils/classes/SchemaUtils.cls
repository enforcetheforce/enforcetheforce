public with sharing class SchemaUtils {

	/**
	 * getFields Returns all fields from a specific SObject
	 * @param  sObjectName       The object API name. Ex: Account, MyCustomObject__c
	 * @param  includeReferences Tells if the method should also return lookup or master-detail fields
	 * @param  updateatableOnly  Tells if the method should return only updateatable fields
	 * @return                   return A map containing the field name as key and field labels as value 
	 */
	public static Map<String, String> getFields( String sObjectName, Boolean includeReferences, Boolean updateatableOnly ) {
		Map<String, String> result = new Map<String, String>();
		Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();	
		for( Schema.SObjectField field : fieldMap.values() ) {
			Schema.DescribeFieldResult describe = field.getDescribe();

			if( describe.isAccessible() ) {
				if( describe.isUpdateable() == updateatableOnly  ) {
					if( (describe.getType() == DisplayType.Reference && includeReferences) || ( describe.getType() != DisplayType.Reference ) ) {
						result.put( describe.getName(), describe.getLabel() );
					}
				}
			}
		}
		return result;
	}

}