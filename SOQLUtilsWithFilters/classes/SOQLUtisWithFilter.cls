public class SOQLUtisWithFilter {
	public final static String EQUALS = '=';
	public final static String GREATER = '>';
	public final static String GREATER_THAN = '>';
	public final static String LESS = '<';
	public final static String LESS_THAN = '<=';
	public final static String IN_VALUES = 'IN';
	public final static String NOT_IN_VALUES = 'NOT IN';

	/**
	 * getQuery 					Returns something like Select * FROM
	 * @param  sObjectType       	The SObject name
	 * @param  includeReferences 	Tells if the method should also return lookup or master-detail fields
	 * @param  updateatableOnly  	Tells if the method should return only updateatable fields
	 * @param  fieldsToExcludeList  Tells which fields must be excluded from select statement.
	 * @return                   	return The query
	 */
	public static String getQuery( String sObjectType, Boolean includeReferences, Boolean updateatableOnly, List<String> fieldsToExcludeList ) {
		String query = 'Select ';
		String result = '';
		Map<String,String> sObjectFields = SchemaUtils.getFields( sObjectType, includeReferences, updateatableOnly );
		for( String fieldName : sObjectFields.keySet() ) {
			result += fieldName + ', ';
		}

		for( String fieldToExclude : fieldsToExcludeList ) {
			result = result.startsWith( fieldToExclude ) ? result.replace( fieldToExclude + ',', '' ) : result.replace(', ' + fieldToExclude + ',', ', ');
		}

		if( result.endsWith(', ') ) {
			result = result.left(result.length()-2);
		}

		query = query + result;
		return query;
	}
	
	/**
	 * getQuery 					Returns something like Select * FROM where ...
	 * @param  sObjectType        	The SObject name
	 * @param  updateatableOnly   	Tells if the method should also return lookup or master-detail fields
	 * @param  includeReferences  	Tells if the method should return only updateatable fields
	 * @param  fieldsToExcludeList  Tells which fields must be excluded from select statement.
	 * @param  filters            	A list of SOQLUtisWithFilter.Filter. Ex: new List<SOQLUtisWithFilter.Filter> { SOQLUtisWithFilter.Filter billingStateFilter = new SOQLUtisWithFilter.Filter('Account', 'BillingState', SOQLUtisWithFilter.EQUALS, new List<String> {'PE'} );) }
	 * @param  filterLogic        	Just any logic condition in Saleforce. Ex: (1 OR 3) AND 2
	 * @return                    	return The query
	 */
	public static String getQuery( String sObjectType, Boolean updateatableOnly, Boolean includeReferences, List<String> fieldsToExcludeList, List<Filter> filters, String filterLogic ) {		
		String result = '';
		String selectClause = getQuery( sObjectType, includeReferences, updateatableOnly, fieldsToExcludeList );
		String whereClause = '';

		Integer index = 1;
		for( Filter filter : filters ) {
			String filterStr =  filter.getFilter();
			filterLogic = filterLogic.replace(String.valueOf(index), filterStr);
			index++;
		}

		result = selectClause + ' from ' + sObjectType + ( filters.size() > 0 ? ' where ' + filterLogic  : '' );		
		return result;
	}

	public class Filter {


		private String sObjectType {get;set;}
		private String field {get;set;}
		private String operator {get;set;}
		private List<String> conditions {get;set;}

		public Filter( String sObjectType, String field, String operator, List<String> conditions ) {
			this.sObjectType = sObjectType;
			this.field = field;
			this.operator = operator;
			this.conditions = conditions;
		}

		public String getFilter() {
			String result = '';
			Schema.SObjectField objectField = Schema.getGlobalDescribe().get(this.sObjectType).getDescribe().fields.getMap().get(this.field);
			if( objectField.getDescribe().getType() == DisplayType.Boolean ||
				objectField.getDescribe().getType() == DisplayType.Combobox ||
				objectField.getDescribe().getType() == DisplayType.Currency ||
				objectField.getDescribe().getType() == DisplayType.Date ||
				objectField.getDescribe().getType() == DisplayType.DateTime ||
				objectField.getDescribe().getType() == DisplayType.Double ||
				objectField.getDescribe().getType() == DisplayType.Integer ||
				objectField.getDescribe().getType() == DisplayType.Percent ||
				objectField.getDescribe().getType() == DisplayType.Time ) {


				result = getFilterNotEnclosed();
			} else {
				result = getFilterEnclosed();
			}
			return result;
		}

		private String getFilterNotEnclosed() {
			return getFilter(false);
		}

		private String getFilterEnclosed() {
			return getFilter(true);
		}

		private String getFilter( Boolean enclosed ) {
			String result = '';
			result = this.field + ' ' + this.operator + ' ';
			if( this.conditions.size() == 1 ) {
				result += (enclosed ? '\'' : '') + conditions.get(0) + (enclosed ? '\'' : '');
			} else {
				result += '(';
				for( String condition : conditions ) {
					result += (enclosed ? '\'' : '') + condition + (enclosed ? '\'' : '') + ',';
				}
				if( result.endsWith(',') ) {
					result = result.left( result.length()-1 );
				}
				result += ')';
			}
			if( result.endsWith(',') ) result = result.left( result.length() - 1 );
			return result;

		}
	}	

}