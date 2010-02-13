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
private with sharing class Sprint_ManageTasksTest {
    public static testmethod void testSelectedStoryId() {
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

        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        sprintController.unsetCachedProperties(); 
        system.assertEquals(story1.Id, sprintController.getSelectedStoryId());
    }

    public static testmethod void testSelectedStoryOptions() {
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

        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        system.assertEquals(2, sprintController.getSelectedStoryOptionsSize()); 
        system.assertEquals('--None--', sprintController.getSelectedStoryOptions().get(0).getLabel());
        system.assertEquals('', sprintController.getSelectedStoryOptions().get(0).getValue());
        system.assertEquals(story1.Name, sprintController.getSelectedStoryOptions().get(1).getLabel());
        system.assertEquals(story1.Id, sprintController.getSelectedStoryOptions().get(1).getValue());
        sprintController.unsetSelectedStoryOptions();
    }

    public static testmethod void testTaskList() {
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

        Task__c task1 = new Task__c();
        task1.Name = 'Task#1';
        task1.Story__c = story1.Id;
        task1.Sprint__c = sprint1.Id;
        insert task1;
        
        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        // sprintController.unsetCachedProperties();

        system.assertEquals(1, sprintController.getSelectedStoryTaskListSize());
        system.assertEquals(task1.Id, sprintController.getSelectedStoryTaskList().get(0).Id);
        sprintController.unsetSelectedStoryTaskList();
    }

    public static testmethod void testTaskList_WhenSelectedStoryIdIsNull() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        system.assertEquals(0, sprintController.getSelectedStoryTaskListSize());
    }

    public static testmethod void testTask() {
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

        Task__c task1 = new Task__c();
        task1.Name = 'Task#1';
        task1.Story__c = story1.Id;
        task1.Sprint__c = sprint1.Id;
        insert task1;
        
        Task__c task2 = new Task__c();
        task2.Name = 'Task#2';
        task2.Story__c = story1.Id;
        task2.Sprint__c = sprint1.Id;
        insert task2;
        
        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        
        system.assertEquals(2, sprintController.getSelectedStoryTaskListSize());
        system.assertEquals(task1.Id, sprintController.getTask(task1.Id).Id);
        system.assertEquals(task2.Id, sprintController.getTask(task2.Id).Id);
    }

    public static testmethod void testTaskListIsInlineEdit() {
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

        Task__c task1 = new Task__c();
        task1.Name = 'Task#1';
        task1.Story__c = story1.Id;
        task1.Sprint__c = sprint1.Id;
        insert task1;
        
        Task__c task2 = new Task__c();
        task2.Name = 'Task#2';
        task2.Story__c = story1.Id;
        task2.Sprint__c = sprint1.Id;
        insert task2;
        
        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        sprintController.unsetCachedProperties();
        system.assertEquals(false, sprintController.getTaskListIsInlineEdit());

        // When selected IDs are missing
        sprintController.enableTaskIsInlineEdit();
        system.assertEquals(false, sprintController.getTaskListIsInlineEdit());

        sprintController.cancelTaskIsInlineEdit();
        system.assertEquals(false, sprintController.getTaskListIsInlineEdit());

        // When using a task unrelated to the original story
        Story__c story2 = new Story__c();
        story2.Name = 'Story#2';
        story2.Sprint__c = sprint1.Id;
        story2.Workstream__c = workstream1.Id;
        insert story2;

        Task__c task3 = new Task__c();
        task3.Name = 'Task#1';
        task3.Story__c = story2.Id;
        task3.Sprint__c = sprint1.Id;
        insert task3;
        
        system.currentPageReference().getParameters().put('selectedId', task3.Id);
        sprintController.enableTaskIsInlineEdit();
        system.assertEquals(false, sprintController.getTaskListIsInlineEdit());
        
        system.currentPageReference().getParameters().put('selectedId', task3.Id);
        sprintController.cancelTaskIsInlineEdit();
        system.assertEquals(false, sprintController.getTaskListIsInlineEdit());

        // All correct
        system.currentPageReference().getParameters().put('selectedId', task1.Id);
        sprintController.enableTaskIsInlineEdit();
        system.assertEquals(true, sprintController.getTaskListIsInlineEdit());
        
        system.currentPageReference().getParameters().put('selectedId', task1.Id);
        sprintController.cancelTaskIsInlineEdit();
        system.assertEquals(false, sprintController.getTaskListIsInlineEdit());
        
        // Test caching - call a second time 
        system.assertEquals(false, sprintController.getTaskListIsInlineEdit());
    }

    public static testmethod void testInsertTask() {
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

        Task__c task1 = new Task__c();
        task1.Name = 'Task#1';
        task1.Story__c = story1.Id;
        task1.Sprint__c = sprint1.Id;
        insert task1;
        
        Task__c task2 = new Task__c();
        task2.Name = 'Task#2';
        task2.Story__c = story1.Id;
        task2.Sprint__c = sprint1.Id;
        insert task2;
        
        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        sprintController.unsetCachedProperties();
        sprintController.insertTask();

        system.assertEquals(true, sprintController.getTaskListIsInlineEdit());
        system.assertEquals(3, sprintController.getSelectedStoryTaskListSize());
    }

    public static testmethod void testInsertTask_WhenTaskListIsEmpty() {
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
        
        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        sprintController.unsetCachedProperties();
        sprintController.insertTask();

        system.assertEquals(true, sprintController.getTaskListIsInlineEdit());
        system.assertEquals(1, sprintController.getSelectedStoryTaskListSize());
    }

    public static testmethod void testEnableTasks() {}

    public static testmethod void testCancelInsertTask() {
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

        Task__c task1 = new Task__c();
        task1.Name = 'Task#1';
        task1.Story__c = story1.Id;
        task1.Sprint__c = sprint1.Id;
        insert task1;
        
        Task__c task2 = new Task__c();
        task2.Name = 'Task#2';
        task2.Story__c = story1.Id;
        task2.Sprint__c = sprint1.Id;
        insert task2;
        
        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        sprintController.unsetCachedProperties();
        sprintController.insertTask();

        system.assertEquals(true, sprintController.getTaskListIsInlineEdit());
        system.assertEquals(3, sprintController.getSelectedStoryTaskListSize()); 

        sprintController.cancelInsertTask();

        system.assertEquals(false, sprintController.getTaskListIsInlineEdit());
        system.assertEquals(2, sprintController.getSelectedStoryTaskListSize()); 
    }

    public static testmethod void testDeleteTask() {
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

        Task__c task1 = new Task__c();
        task1.Name = 'Task#1';
        task1.Story__c = story1.Id;
        task1.Sprint__c = sprint1.Id;
        insert task1;
        
        Task__c task2 = new Task__c();
        task2.Name = 'Task#2';
        task2.Story__c = story1.Id;
        task2.Sprint__c = sprint1.Id;
        insert task2;
        
        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        sprintController.unsetCachedProperties();

        // When selected IDs are missing
        sprintController.deleteTask();
        system.assertEquals(2, sprintController.getSelectedStoryTaskListSize());

        // When using a task unrelated to the original story
        Story__c story2 = new Story__c();
        story2.Name = 'Story#2';
        story2.Sprint__c = sprint1.Id;
        story2.Workstream__c = workstream1.Id;
        insert story2;

        Task__c task3 = new Task__c();
        task3.Name = 'Task#1';
        task3.Story__c = story2.Id;
        task3.Sprint__c = sprint1.Id;
        insert task3;
        
        system.currentPageReference().getParameters().put('selectedId', task3.Id);
        sprintController.deleteTask();
        system.assertEquals(2, sprintController.getSelectedStoryTaskListSize());

        // All correct
        system.currentPageReference().getParameters().put('selectedId', task1.Id);
        sprintController.deleteTask();
        system.assertEquals(1, sprintController.getSelectedStoryTaskListSize());
        system.assertEquals(0, [
            select COUNT()
              from Task__c
             where Id = :task1.Id
        ]);
    }

    public static testmethod void testSaveTaskList() {
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

        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        //sprintController.unsetCachedProperties();
        sprintController.saveTaskList();
        
        system.assertEquals(0, sprintController.getSelectedStoryTaskListSize());

        Task__c task1 = new Task__c();
        task1.Name = 'Task#1';
        task1.Story__c = story1.Id;
        task1.Sprint__c = sprint1.Id;
        insert task1;
        
        sprintController.unsetCachedProperties();
        sprintController.getTask(task1.Id).Name = 'Task#1#Updated';
        sprintController.saveTaskList();
        
        system.assertEquals(1, sprintController.getSelectedStoryTaskListSize());
        system.assertEquals('Task#1#Updated', [
            select Name
              from Task__c
             where Id = :task1.Id
        ].Name);
    }

    public static testmethod void testSaveTaskListAndReturn() {}

    public static testmethod void testSaveTaskListAndInsert() {
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

        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        sprintController.unsetCachedProperties();

        sprintController.saveTaskListAndInsert();
        system.assertEquals(0, sprintController.getSelectedStoryTaskListSize());

        sprintController.cancelInsertTask();
        system.assertEquals(0, sprintController.getSelectedStoryTaskListSize());

        Task__c task1 = new Task__c();
        task1.Name = 'Task#1';
        task1.Story__c = story1.Id;
        task1.Sprint__c = sprint1.Id;
        insert task1;
        
        sprintController.unsetCachedProperties();
        sprintController.getTask(task1.Id).Name = 'Task#1#Updated';
        sprintController.saveTaskListAndInsert();

        system.assertEquals(2, sprintController.getSelectedStoryTaskListSize(), ApexPages.getMessages());
        system.assertEquals('Task#1#Updated', [
            select Name
              from Task__c
             where Id = :task1.Id
        ].Name);
        system.assertEquals(true, sprintController.getTaskListIsInlineEdit());
    }

    public static testmethod void testRedirectManageStories() {
        Workstream__c workstream1 = new Workstream__c();
        workstream1.Name = 'Workstream#1';
        insert workstream1; 
        
        Sprint__c sprint1 = new Sprint__c();
        sprint1.Name = 'Sprint#1';
        sprint1.StartsOn__c = Date.today();
        sprint1.CompletesOn__c = Date.today().addDays(1);
        sprint1.Workstream__c = workstream1.Id;
        insert sprint1;
        
        new Sprint_ManageTasks(new ApexPages.StandardController(sprint1)).redirectManageStories();
    }

    public static testmethod void testEnableTaskListIsInlineEdit() {
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

        Task__c task1 = new Task__c();
        task1.Name = 'Task#1';
        task1.Story__c = story1.Id;
        task1.Sprint__c = sprint1.Id;
        insert task1;
        
        Task__c task2 = new Task__c();
        task2.Name = 'Task#2';
        task2.Story__c = story1.Id;
        task2.Sprint__c = sprint1.Id;
        insert task2;
        
        Task__c task3 = new Task__c();
        task3.Name = 'Task#3';
        task3.Story__c = story1.Id;
        task3.Sprint__c = sprint1.Id;
        insert task3;
        
        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.setSelectedStoryId(story1.Id);
        sprintController.unsetCachedProperties();
        
        for(Task__c task : sprintController.getSelectedStoryTaskList())
            system.assertEquals(false, task.IsInlineEdit__c);

        sprintController.enableTaskListIsInlineEdit();

        for(Task__c task : sprintController.getSelectedStoryTaskList())
            system.assertEquals(true, task.IsInlineEdit__c);
    }

    public static testmethod void testUpdateSelectedStory() {
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

        Sprint_ManageTasks sprintController = new Sprint_ManageTasks(new ApexPages.StandardController(sprint1));
        sprintController.updateSelectedStory();
    }
}