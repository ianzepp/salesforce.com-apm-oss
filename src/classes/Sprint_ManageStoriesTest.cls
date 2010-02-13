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
private with sharing class Sprint_ManageStoriesTest { 
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
        
        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        sprintController.setIncludeBacklog(true);       
        sprintController.unsetIncludeBacklog();
        sprintController.updateIncludeBacklog();  
    }
    
    public static testmethod void testRemovedStory() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Story__c story1 = new Story__c();
        story1.Name = 'Story';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;

        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        sprintController.setRemovedStory(story1);

        system.assert(null != sprintController.getRemovedStory());     
        system.assertEquals(story1.Id, sprintController.getRemovedStory().Id);     
    }
    
    public static testmethod void testStoryList() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        system.assertEquals(0, sprintController.getStoryListSize());

        Story__c story1 = new Story__c();
        story1.Name = 'Story';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;

        sprintController.unsetCachedProperties();
        system.assertEquals(1, sprintController.getStoryListSize());
        system.assertEquals(story1.Id, sprintController.getStoryList().get(0).Id);
        
        // include backlog stories
        Story__c story2 = new Story__c();
        story2.Name = 'Story';
        story2.Sprint__c = null; // no sprint assigned
        story2.Workstream__c = workstream1.Id;
        insert story2;

        sprintController.unsetCachedProperties();
        sprintController.setIncludeBacklog(true);
        system.assertEquals(2, sprintController.getStoryListSize());
    }

    public static testmethod void testStory() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
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

        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        
        system.assertEquals(2, sprintController.getStoryListSize());
        system.assertEquals(story1.Id, sprintController.getStory(story1.Id).Id);
        system.assertEquals(story2.Id, sprintController.getStory(story2.Id).Id);
    }

    public static testmethod void testStoryListIsInlineEdit() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
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

        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());

        // When selected IDs are missing
        sprintController.enableStoryIsInlineEdit();
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());

        sprintController.cancelStoryIsInlineEdit();
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());

        // When using a task unrelated to the original story
        Story__c story3 = new Story__c();
        story3.Name = 'Story#3';
        story3.Sprint__c = sprint1.Id;
        story3.Workstream__c = workstream1.Id;
        insert story3;
        
        system.currentPageReference().getParameters().put('selectedId', story3.Id);
        sprintController.enableStoryIsInlineEdit();
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());
        
        system.currentPageReference().getParameters().put('selectedId', story3.Id);
        sprintController.cancelStoryIsInlineEdit();
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());

        // All correct
        system.currentPageReference().getParameters().put('selectedId', story1.Id);
        sprintController.enableStoryIsInlineEdit();
        system.assertEquals(true, sprintController.getStoryListIsInlineEdit());
        
        system.currentPageReference().getParameters().put('selectedId', story1.Id);
        sprintController.cancelStoryIsInlineEdit();
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());
        
        // Test caching - call a second time 
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());
    }

    public static testmethod void testAssignStory() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Story__c story1 = new Story__c();
        story1.Name = 'Story';
        story1.Sprint__c = null; // no sprint
        story1.Workstream__c = workstream1.Id;
        insert story1;

        system.assert(sprint1.Id != [
            select Sprint__c
              from Story__c
             where Id = :story1.Id
        ].Sprint__c);

        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));

        system.currentPageReference().getParameters().put('selectedId', story1.Id);
        sprintController.setIncludeBacklog(true);
        sprintController.unsetCachedProperties();
        sprintController.assignStory();

        system.assertEquals(0, sprintController.getMessageListSize(ApexPages.Severity.ERROR), ApexPages.getMessages());
        system.assert(sprint1.Id == [
            select Sprint__c
              from Story__c
             where Id = :story1.Id
        ].Sprint__c);
    }
    
    public static testmethod void testRemoveStory() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Story__c story1 = new Story__c();
        story1.Name = 'Story';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;

        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));

        system.currentPageReference().getParameters().put('selectedId', story1.Id);
        sprintController.removeStory();

        system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
        system.assert(null != sprintController.getRemovedStory());
        system.assertEquals(story1.Id, sprintController.getRemovedStory().Id);

        sprintController.cancelRemoveStory();

        system.assertEquals(null, sprintController.getRemovedStory());
    }
    
    public static testmethod void testInsertStory() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));

        system.assertEquals(0, sprintController.getStoryListSize());
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());

        sprintController.insertStory();

        system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
        system.assertEquals(1, sprintController.getStoryListSize());
        system.assertEquals(true, sprintController.getStoryListIsInlineEdit());

        sprintController.cancelInsertStory();

        system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
        system.assertEquals(0, sprintController.getStoryListSize());
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());

        Story__c story1 = new Story__c();
        story1.Name = 'Story';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;

        sprintController.unsetCachedProperties();        

        system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
        system.assertEquals(1, sprintController.getStoryListSize());
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());

        sprintController.insertStory();
        
        system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
        system.assertEquals(2, sprintController.getStoryListSize());
        system.assertEquals(true, sprintController.getStoryListIsInlineEdit());

        sprintController.cancelInsertStory();

        system.assertEquals(0, ApexPages.getMessages().size(), ApexPages.getMessages());
        system.assertEquals(1, sprintController.getStoryListSize());
        system.assertEquals(false, sprintController.getStoryListIsInlineEdit());
    }

    public static testmethod void testDeleteStory() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
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

        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));

        // When selected IDs are missing
        sprintController.deleteStory();
        sprintController.unsetCachedProperties();
        system.assertEquals(2, sprintController.getStoryListSize());

        // When using a story unrelated to the original sprint
        Sprint__c sprint2 = new Sprint__c();
        sprint2.Name = 'Sprint#2';
        sprint2.StartsOn__c = Date.today();
        sprint2.CompletesOn__c = Date.today().addDays(1);
        sprint2.Workstream__c = workstream1.Id;
        insert sprint2;
        
        Story__c story3 = new Story__c();
        story3.Name = 'Story#3';
        story3.Sprint__c = sprint2.Id;
        story3.Workstream__c = workstream1.Id;
        insert story3;

        system.currentPageReference().getParameters().put('selectedId', story3.Id);
        sprintController.deleteStory();
        sprintController.unsetCachedProperties();
        system.assertEquals(2, sprintController.getStoryListSize());

        // All correct
        system.currentPageReference().getParameters().put('selectedId', story1.Id);
        sprintController.deleteStory();
        sprintController.unsetCachedProperties();
        system.assertEquals(1, sprintController.getStoryListSize());
        system.assertEquals(0, [
            select COUNT()
              from Story__c
             where Id = :story1.Id
        ]);
    }

    public static testmethod void testSaveStoryList() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        sprintController.saveStoryList();
        system.assertEquals(0, sprintController.getStoryListSize());

        Story__c story1 = new Story__c();
        story1.Name = 'Story#1';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;
        
        sprintController.unsetCachedProperties();
        sprintController.getStory(story1.Id).Name = 'Story#1#Updated';
        sprintController.saveStoryList();
        
        system.assertEquals(1, sprintController.getStoryListSize());
        system.assertEquals('Story#1#Updated', [
            select Name
              from Story__c
             where Id = :story1.Id
        ].Name);
    }

    public static testmethod void testSaveStoryListAndInsert() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));

        sprintController.saveStoryListAndInsert();        
        system.assertEquals(1, sprintController.getStoryListSize());

        sprintController.cancelInsertStory();
        system.assertEquals(0, sprintController.getStoryListSize());

        Story__c story1 = new Story__c();
        story1.Name = 'Story#1';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;

        sprintController.unsetCachedProperties();
        sprintController.getStory(story1.Id).Name = 'Story#1#Updated';
        sprintController.saveStoryListAndInsert();

        system.assertEquals(2, sprintController.getStoryListSize());
        system.assertEquals('Story#1#Updated', [
            select Name
              from Story__c
             where Id = :story1.Id
        ].Name);
        system.assertEquals(true, sprintController.getStoryListIsInlineEdit());
        
        // Include here, no better place
        sprintController.saveStoryListAndReturn();
    }

    public static testmethod void testRedirectManageTasks() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        new Sprint_ManageStories(new ApexPages.StandardController(sprint1)).redirectManageTasks();
    }

    public static testmethod void testEnableStoryListIsInlineEdit() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Story__c story1 = new Story__c();
        story1.Name = 'Story';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;

        Story__c story2 = new Story__c();
        story2.Name = 'Story';
        story2.Sprint__c = sprint1.Id;
        story2.Workstream__c = workstream1.Id;
        insert story2;

        Story__c story3 = new Story__c();
        story3.Name = 'Story';
        story3.Sprint__c = sprint1.Id;
        story3.Workstream__c = workstream1.Id;
        insert story3;

        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        
        for(Story__c story : sprintController.getStoryList())
            system.assertEquals(false, story.IsInlineEdit__c);

        sprintController.enableStoryListIsInlineEdit();

        for(Story__c story : sprintController.getStoryList())
            system.assertEquals(true, story.IsInlineEdit__c);
    }

    public static testmethod void testWorkstreamRoleOptions() {
        Sprint__c sprint1 = new Sprint__c();
        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        sprintController.getSprintUserOptions();
    }
    
    public static testmethod void testSprintUserOptions() {
        Sprint__c sprint1 = new Sprint__c();
        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        sprintController.getSprintUserOptions();
    }
    
    public static testmethod void testCancel() {
        Sprint__c sprint1 = new Sprint__c();
        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        sprintController.cancel();
    }
    
    public static testmethod void testConfirmRemoveStory() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Story__c story1 = new Story__c();
        story1.Name = 'Story';
        story1.Sprint__c = sprint1.Id;
        story1.Workstream__c = workstream1.Id;
        insert story1;

        Story__c story2 = new Story__c();
        story2.Name = 'Story';
        story2.Sprint__c = sprint1.Id;
        story2.Workstream__c = workstream1.Id;
        insert story2;

        Story__c story3 = new Story__c();
        story3.Name = 'Story';
        story3.Sprint__c = sprint1.Id;
        story3.Workstream__c = workstream1.Id;
        insert story3;

        Sprint_ManageStories sprintController = new Sprint_ManageStories(new ApexPages.StandardController(sprint1));
        sprintController.setPageParam('selectedId', story3.Id);
        sprintController.removeStory();
        sprintController.confirmRemoveStory();
        
        system.assert(sprint1.Id != [
            select Sprint__c
              from Story__c
             where Id = :story3.Id
        ].Sprint__c);
    }
    
}