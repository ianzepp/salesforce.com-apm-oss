/**
 * Agile Process Management (OSS)
 *
 * Copyright (C) 2009 - 2010, Ian Zepp <ian.zepp@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
@IsTest
private with sharing class Sprint_ManageCasesTest {
    public static testmethod void testIncludeBacklog() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));

        // getter/setter for include backlog
        sprintController.setIncludeBacklog(true);
        system.assertEquals(true, sprintController.getIncludeBacklog());
        
        sprintController.setIncludeBacklog(false);
        system.assertEquals(false, sprintController.getIncludeBacklog());

        sprintController.unsetIncludeBacklog();
        system.assertEquals(false, sprintController.getIncludeBacklog());
    }
    
    public static testmethod void testSaveWorkstreamCases_WithoutCases() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.saveWorkstreamCaseList();
    } 

    public static testmethod void testSaveWorkstreamCases_WithCases() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Case case1 = new Case();
        case1.Subject = 'Case#1';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        insert workstreamCase1;
        
        Case case2 = new Case();
        case2.Subject = 'Case#2';
        insert case2;

        WorkstreamCase__c workstreamCase2 = new WorkstreamCase__c();
        workstreamCase2.Workstream__c = workstream1.Id;
        workstreamCase2.Case__c = case2.Id;
        insert workstreamCase2;
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.saveWorkstreamCaseList();
    }

    public static testmethod void testSaveWorkstreamCasesAndReturn_WithoutCases() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        system.assert(null != sprintController.saveWorkstreamCaseListAndReturn(), ApexPages.getMessages());
    }

    public static testmethod void testSaveWorkstreamCasesAndReturn_WithCases_NotInSprint() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Case case1 = new Case();
        case1.Subject = 'Case#1';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        insert workstreamCase1;
        
        Case case2 = new Case();
        case2.Subject = 'Case#2';
        insert case2;

        WorkstreamCase__c workstreamCase2 = new WorkstreamCase__c();
        workstreamCase2.Workstream__c = workstream1.Id;
        workstreamCase2.Case__c = case2.Id;
        insert workstreamCase2;
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        system.assert(null != sprintController.saveWorkstreamCaseListAndReturn(), ApexPages.getMessages());
    }

    public static testmethod void testSaveWorkstreamCasesAndReturn_WithCases_InSprint() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Case case1 = new Case();
        case1.Subject = 'Case#1';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Sprint__c = sprint1.Id;
        insert workstreamCase1;
        
        Case case2 = new Case();
        case2.Subject = 'Case#2';
        insert case2;

        WorkstreamCase__c workstreamCase2 = new WorkstreamCase__c();
        workstreamCase2.Workstream__c = workstream1.Id;
        workstreamCase2.Case__c = case2.Id;
        workstreamCase2.Sprint__c = sprint1.Id;
        insert workstreamCase2;
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.saveWorkstreamCaseListAndReturn();
    }

    public static testmethod void testInsertWorkstreamCases() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Case case1 = new Case();
        case1.Subject = 'Case#1';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        insert workstreamCase1;
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.getNewWorkstreamCase().Case__c = case1.Id;
        sprintController.insertWorkstreamCase();
    }

    public static testmethod void testDeleteWorkstreamCases() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Case case1 = new Case();
        case1.Subject = 'Case#1';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Sprint__c = sprint1.Id;
        insert workstreamCase1;
        
        Case case2 = new Case();
        case2.Subject = 'Case#2';
        insert case2;

        WorkstreamCase__c workstreamCase2 = new WorkstreamCase__c();
        workstreamCase2.Workstream__c = workstream1.Id;
        workstreamCase2.Case__c = case2.Id;
        workstreamCase2.Sprint__c = sprint1.Id;
        insert workstreamCase2;
        
        sprint1 = [
            select (select Name from WorkstreamCases__r)
              from Sprint__c
             where Id = :sprint1.Id
        ];
        
        ApexPages.currentPage().getParameters().put('selectedId', workstreamCase1.Id);
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.deleteWorkstreamCase();
    }

    public static testmethod void testGetWorkstreamCaseListSize_WithoutIncludeBacklog() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Case case1 = new Case();
        case1.Subject = 'Case#1';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Sprint__c = sprint1.Id;
        insert workstreamCase1;
        
        sprint1 = [
            select (select Name from WorkstreamCases__r)
              from Sprint__c
             where Id = :sprint1.Id
        ];
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.setIncludeBacklog(false);
        system.assertEquals(1, sprintController.getWorkstreamCaseListSize(), ApexPages.getMessages());
    }

    public static testmethod void testGetWorkstreamCaseListSize_WithIncludeBacklog() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Case case1 = new Case();
        case1.Subject = 'Case#1';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Sprint__c = sprint1.Id;
        insert workstreamCase1;
        
        // refresh sprint object - otherwise we get an:
        //
        // SObject row was retrieved via SOQL without querying the requested field:
        //        - Sprint__c.Workstream__c
        //            

        sprint1 = [
            select Name
                 , StartsOn__c
                 , CompletesOn__c
                 , Workstream__c
                 , (select Name from WorkstreamCases__r)
              from Sprint__c
             where Id = :sprint1.Id
        ];
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.setIncludeBacklog(true);
        system.assertEquals(1, sprintController.getWorkstreamCaseListSize(), ApexPages.getMessages());
    }

    public static testmethod void testGetSprintOptions() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        // backlog sprint is auto-created

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        // refresh sprint object - otherwise we get an:
        //
        // SObject row was retrieved via SOQL without querying the requested field:
        //        - Sprint__c.Workstream__c
        //            

        sprint1 = [
            select Workstream__c
              from Sprint__c
             where Id = :sprint1.Id
        ];
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        system.assertEquals(3, sprintController.getSprintOptionsSize(), ApexPages.getMessages());
    }

    public static testmethod void testGetStoryOptions() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        // backlog sprint is auto-created

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Story__c story1 = new Story__c();
        story1.Name = 'Story#1';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;

        Story__c story2 = new Story__c();
        story2.Name = 'Story#2';
        story2.Sprint__c = sprint1.Id;
        story2.Workstream__c = workstream1.Id;
        insert story2;

        // refresh sprint object - otherwise we get an:
        //
        // SObject row was retrieved via SOQL without querying the requested field:
        //        - Sprint__c.Workstream__c
        //            

        sprint1 = [
            select Workstream__c
              from Sprint__c
             where Id = :sprint1.Id
        ];
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        system.assertEquals(3, sprintController.getStoryOptionsSize(), ApexPages.getMessages());
    }
    
    public static testmethod void testAssignWorkstreamCaseAndConvert_NullSelectedId() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        // backlog sprint is auto-created

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.assignWorkstreamCaseAndConvert();

        system.assertEquals('Internal Error: required parameter "selectedId" is missing', ApexPages.getMessages()[0].getSummary(), ApexPages.getMessages());
    }

    public static testmethod void testAssignWorkstreamCaseAndConvert_InvalidSelectedWorkstreamCaseId() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        // backlog sprint is auto-created

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Case case1 = new Case();
        case1.Subject = 'Case#1';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Sprint__c = sprint1.Id;
        insert workstreamCase1;
        
        //
        // Create another case in another sprint
        //
        
        Sprint__c sprint2 = new Sprint__c();
        sprint2.Name = 'Sprint#2';
        sprint2.StartsOn__c = Date.today();
        sprint2.CompletesOn__c = Date.today().addDays(1);
        sprint2.Workstream__c = workstream1.Id;
        insert sprint2;
        
        Case case2 = new Case();
        case2.Subject = 'Case#2';
        insert case2;

        WorkstreamCase__c workstreamCase2 = new WorkstreamCase__c();
        workstreamCase2.Workstream__c = workstream1.Id;
        workstreamCase2.Case__c = case2.Id;
        workstreamCase2.Sprint__c = sprint2.Id;
        insert workstreamCase2;
        
        // refresh sprint object - otherwise we get an:
        //
        // SObject row was retrieved via SOQL without querying the requested field:
        //        - Sprint__c.Workstream__c
        //            

        sprint1 = [
            select Name
                 , StartsOn__c
                 , CompletesOn__c
                 , Workstream__c
                 , (select Name from WorkstreamCases__r)
              from Sprint__c
             where Id = :sprint1.Id
        ];
        
        ApexPages.currentPage().getParameters().put('selectedId', workstreamCase2.Id);
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.assignWorkstreamCaseAndConvert();

        system.assert(ApexPages.getMessages()[0].getSummary().contains('Internal Error: no matching workstream case for that "selectedId" parameter exists in the list of workstream cases:'), ApexPages.getMessages());
    }

    public static testmethod void testAssignWorkstreamCaseAndConvert() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        // backlog sprint is auto-created

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Case case1 = new Case();
        case1.Subject = 'Case#1';
        insert case1;

        WorkstreamCase__c workstreamCase1 = new WorkstreamCase__c();
        workstreamCase1.Workstream__c = workstream1.Id;
        workstreamCase1.Case__c = case1.Id;
        workstreamCase1.Sprint__c = sprint1.Id;
        insert workstreamCase1;
        
        // refresh sprint object - otherwise we get an:
        //
        // SObject row was retrieved via SOQL without querying the requested field:
        //        - Sprint__c.Workstream__c
        //            

        sprint1 = [
            select Name
                 , StartsOn__c
                 , CompletesOn__c
                 , Workstream__c
                 , (select Name from WorkstreamCases__r)
              from Sprint__c
             where Id = :sprint1.Id
        ];
        
        ApexPages.currentPage().getParameters().put('selectedId', workstreamCase1.Id);
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.assignWorkstreamCaseAndConvert();
        system.assertEquals('Changes were successfully saved.', ApexPages.getMessages()[0].getSummary(), ApexPages.getMessages());
    }

    public static testmethod void testUpdateIncludeBacklog() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        // backlog sprint is auto-created

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        // refresh sprint object - otherwise we get an:
        //
        // SObject row was retrieved via SOQL without querying the requested field:
        //        - Sprint__c.Workstream__c
        //            

        sprint1 = [
            select Workstream__c
              from Sprint__c
             where Id = :sprint1.Id
        ];
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.updateIncludeBacklog();
    }

    public static testmethod void testRedirectManageStories() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 

        // backlog sprint is auto-created

        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        // refresh sprint object - otherwise we get an:
        //
        // SObject row was retrieved via SOQL without querying the requested field:
        //        - Sprint__c.Workstream__c
        //            

        sprint1 = [
            select Workstream__c
              from Sprint__c
             where Id = :sprint1.Id
        ];
        
        Sprint_ManageCases sprintController = new Sprint_ManageCases(new ApexPages.StandardController(sprint1));
        sprintController.redirectManageStories();
    }
}