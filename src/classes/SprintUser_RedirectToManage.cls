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

public with sharing class SprintUser_RedirectToManage extends Common_AbstractExtension {
    public SprintUser_RedirectToManage(ApexPages.StandardController controller) {
        super(controller);
    }
    
    public Id getSprintId() {
        return ((SprintUser__c) getControllerRecord()).Sprint__c;
    }
    
    public PageReference redirect() {
        PageReference pageReference = System.Page.Sprint_ManageUsers;
        pageReference.getParameters().put('id', getSprintId());
        pageReference.setRedirect(true);
        return pageReference;
    }
}