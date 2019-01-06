SOQLUtisWithFilter.Filter billingCityFilter = 
    new SOQLUtisWithFilter.Filter('Account','BillingCity',SOQLUtisWithFilter.EQUALS, new List<String> {'Recife'});
SOQLUtisWithFilter.Filter billingStateFilter = 
    new SOQLUtisWithFilter.Filter('Account','BillingState',SOQLUtisWithFilter.EQUALS, new List<String> {'PE'});
String query = SOQLUtisWithFilter.getQuery('Account', 
                                           false, 
                                           true, 
                                           new List<String> {'ParentId'}, 
                                           new List<SOQLUtisWithFilter.Filter> {billingCityFilter,billingStateFilter }, 
                                           '1 AND 2');
System.debug(query);
List<Account> accs = Database.query( query );
System.debug(accs);