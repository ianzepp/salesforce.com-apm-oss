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

public with sharing virtual class Common_AbstractExtension {
    public ApexPages.StandardController controller {
        set;
        get;
    }

    // Controller
    public Common_AbstractExtension() {}

    public Common_AbstractExtension(ApexPages.StandardController controller) {
        setController(controller);
    }
    
    public ApexPages.StandardController getController() {
        return controller;
    }

    public void setController(ApexPages.StandardController controller) {
        this.controller = controller;
    }

    public Id getControllerId() {
        return controller == null ? null : controller.getId();
    }

    public Sobject getControllerRecord() {
        return controller == null ? null : controller.getRecord();
    }

    // Page parameters
    public Map<String, String> getPageParameters() {
        return system.currentPageReference().getParameters();
    }

    public String getPageParam(String name) {
        return getPageParameters().get(name);
    }

    public void setPageParam(String name, String value) {
        getPageParameters().put(name, value);
    }

    // Message and Exception handling
    public void addMessage(String message) {
        addMessage(ApexPages.Severity.INFO, message);
    }

    public void addMessage(ApexPages.Severity severity, String message) {
        ApexPages.addMessage(new ApexPages.Message(severity, message));
    }

    public void addExceptionMessage(Exception excp) {
        ApexPages.addMessages(excp);
    }
 
    public void addChangesSavedMessage() {
        addMessage(ApexPages.Severity.CONFIRM, System.Label.Common_ChangesSuccessfullySaved);
    }
    
    public List<ApexPages.Message> getMessageList() {
        return ApexPages.getMessages();
    }

    public Integer getMessageListSize() {
        return getMessageList().size();
    }
    
    public Integer getMessageListSize(ApexPages.Severity severity) {
        Integer messageListSize = 0;
        
        for(ApexPages.Message message : getMessageList()) {
            if (message.getSeverity() == severity)
                messageListSize ++;
        }
        
        return messageListSize;
    }
}