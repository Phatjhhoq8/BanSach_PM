// 
// Updates an ApplicationHost.config file in the current user's
// profile directory from IIS 7.5 Express to IIS 10.0 Express.
// 

var strCommitPath = "MACHINE/WEBROOT/APPHOST";
var strFirstItem  = "##FIRST#ITEM##";
var strLastItem   = "##LAST#ITEM##";

// ------------------------------------------------------------
// Check for an existing ApplicationHost.config file.
// ------------------------------------------------------------

var objFSO = new ActiveXObject("scripting.filesystemobject");
var strUserConfig = GetUserDirectory() + "\\config\\ApplicationHost.config";
if (objFSO.FileExists(strUserConfig))
{
	// Backup existing an existing ApplicationHost.config file.
	try
	{
		var dtmDate = new Date();
		var strDate = dtmDate.getYear().toString() + 
			PadNumber(dtmDate.getMonth()+1) + 
			PadNumber(dtmDate.getDate()) + 
			PadNumber(dtmDate.getHours()) + 
			PadNumber(dtmDate.getMinutes()) + 
			PadNumber(dtmDate.getSeconds());
	 	objFSO.CopyFile(strUserConfig,strUserConfig + "." + strDate + ".bak",true);
	}
	catch(e)
	{
		ErrorMessage(e,"An error occurred trying to back up your ApplicationHost.config file");
	}
}
else
{
	// Exit if no applicationhost.config file exists. (This is not an error condition.)
	WScript.Echo("No ApplicationHost.config file exists in the current user's profile directory - exiting.");
	WScript.Quit(0);
}

// ------------------------------------------------------------
// Retrieve the necessary objects for the rest of the script.
// ------------------------------------------------------------

WScript.Echo("Migrating your ApplicationHost.config file...\n");
var objAdminManager      = GetAdminManager();
var objConfigManager     = objAdminManager.ConfigManager;
var objAppHostConfig     = objConfigManager.GetConfigFile(strCommitPath);
var objRootSectionGroup  = objAppHostConfig.RootSectionGroup;

// ------------------------------------------------------------
WScript.Echo("...adding new section groups...");
// ------------------------------------------------------------

var objSystemWebServer = FindSectionGroup(objRootSectionGroup,"system.webServer");
AddSection(objSystemWebServer,"applicationInitialization","Allow","MachineToApplication","");
AddSection(objSystemWebServer,"webSocket","Deny","","");
var objSecurity = FindSectionGroup(objSystemWebServer,"security");
AddSection(objSecurity,"dynamicIpSecurity","Deny","","");

// ------------------------------------------------------------
WScript.Echo("...adding new global modules...");
// ------------------------------------------------------------

var objGlobalModules = objAdminManager.GetAdminSection("system.webServer/globalModules", strCommitPath);
AddGlobalModule(objGlobalModules.Collection,"DynamicIpRestrictionModule","%IIS_BIN%\\diprestr.dll","","IpRestrictionModule");
AddGlobalModule(objGlobalModules.Collection,"ApplicationInitializationModule","%IIS_BIN%\\warmup.dll","","ConfigurationValidationModule");
AddGlobalModule(objGlobalModules.Collection,"WebSocketModule","%IIS_BIN%\\iiswsock.dll","","ApplicationInitializationModule");
AddGlobalModule(objGlobalModules.Collection,"ManagedEngine64","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\webengine.dll","integratedMode,runtimeVersionv2.0,bitness64","ManagedEngine");
AddGlobalModule(objGlobalModules.Collection,"ManagedEngineV4.0_64bit","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\webengine4.dll","integratedMode,runtimeVersionv4.0,bitness64","ManagedEngineV4.0_32bit");

// ------------------------------------------------------------
WScript.Echo("...adding new ISAPI filters...");
// ------------------------------------------------------------

var objIsapiFilters = objAdminManager.GetAdminSection("system.webServer/isapiFilters", strCommitPath);
AddIsapiFilter(objIsapiFilters.Collection,"ASP.Net_2.0.50727-64","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_filter.dll","","true","bitness64,runtimeVersionv2.0",strFirstItem);
AddIsapiFilter(objIsapiFilters.Collection,"ASP.Net_4.0_64bit","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_filter.dll","","true","bitness64,runtimeVersionv4.0","ASP.Net_4.0_32bit");

// ------------------------------------------------------------
WScript.Echo("...adding new ISAPI/CGI restrictions...");
// ------------------------------------------------------------

var objIsapiCgiRestrictions = objAdminManager.GetAdminSection("system.webServer/security/isapiCgiRestriction", strCommitPath);
AddIsapiCgiRestriction(objIsapiCgiRestrictions.Collection,"%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\webengine4.dll","true","ASP.NET_v4.0","ASP.NET_v4.0",strFirstItem);
AddIsapiCgiRestriction(objIsapiCgiRestrictions.Collection,"%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","true","ASP.NET v2.0.50727","ASP.NET v2.0.50727",strLastItem);
AddIsapiCgiRestriction(objIsapiCgiRestrictions.Collection,"%windir%\\Microsoft.NET\\Framework\\v2.0.50727\\aspnet_isapi.dll","true","ASP.NET v2.0.50727","ASP.NET v2.0.50727",strLastItem);

// ------------------------------------------------------------
WScript.Echo("...adding new MIME maps...");
// ------------------------------------------------------------

var objStaticContent = objAdminManager.GetAdminSection("system.webServer/staticContent", strCommitPath);
AddMimeMap(objStaticContent.Collection,".3g2","video/3gpp2");
AddMimeMap(objStaticContent.Collection,".3gp2","video/3gpp2");
AddMimeMap(objStaticContent.Collection,".3gp","video/3gpp");
AddMimeMap(objStaticContent.Collection,".3gpp","video/3gpp");
AddMimeMap(objStaticContent.Collection,".aac","audio/aac");
AddMimeMap(objStaticContent.Collection,".adt","audio/vnd.dlna.adts");
AddMimeMap(objStaticContent.Collection,".adts","audio/vnd.dlna.adts");
AddMimeMap(objStaticContent.Collection,".cab","application/vnd.ms-cab-compressed");
AddMimeMap(objStaticContent.Collection,".dvr-ms","video/x-ms-dvr");
AddMimeMap(objStaticContent.Collection,".eot","application/vnd.ms-fontobject");
AddMimeMap(objStaticContent.Collection,".js","application/javascript");
AddMimeMap(objStaticContent.Collection,".m2ts","video/vnd.dlna.mpeg-tts");
AddMimeMap(objStaticContent.Collection,".m4a","audio/mp4");
AddMimeMap(objStaticContent.Collection,".m4v","video/mp4");
AddMimeMap(objStaticContent.Collection,".mp4","video/mp4");
AddMimeMap(objStaticContent.Collection,".mp4v","video/mp4");
AddMimeMap(objStaticContent.Collection,".oga","audio/ogg");
AddMimeMap(objStaticContent.Collection,".ogg","video/ogg");
AddMimeMap(objStaticContent.Collection,".ogv","video/ogg");
AddMimeMap(objStaticContent.Collection,".ogx","application/ogg");
AddMimeMap(objStaticContent.Collection,".otf","font/otf");
AddMimeMap(objStaticContent.Collection,".spx","audio/ogg");
AddMimeMap(objStaticContent.Collection,".svg","image/svg+xml");
AddMimeMap(objStaticContent.Collection,".svgz","image/svg+xml");
AddMimeMap(objStaticContent.Collection,".ts","video/vnd.dlna.mpeg-tts");
AddMimeMap(objStaticContent.Collection,".tts","video/vnd.dlna.mpeg-tts");
AddMimeMap(objStaticContent.Collection,".webm","video/webm");
AddMimeMap(objStaticContent.Collection,".woff","font/x-woff");
AddMimeMap(objStaticContent.Collection,".wtv","video/x-ms-wtv");
AddMimeMap(objStaticContent.Collection,".xht","application/xhtml+xml");
AddMimeMap(objStaticContent.Collection,".xhtml","application/xhtml+xml");

// ------------------------------------------------------------
WScript.Echo("...adding new trace provider definitions...");
// ------------------------------------------------------------

var objTraceProviderDefinitions = objAdminManager.GetAdminSection("system.webServer/tracing/traceProviderDefinitions", strCommitPath);
AddTraceProviderDefinitions(objTraceProviderDefinitions.Collection,"WWW Server","WebSocket","16384");

// ------------------------------------------------------------
WScript.Echo("...updating trace areas...");
// ------------------------------------------------------------

var objTraceAreas = objAdminManager.GetAdminSection("system.webServer/tracing/traceFailedRequests", strCommitPath);
UpdateTraceAreas(objTraceAreas.Collection,"WWW Server","Authentication,Security,Filter,StaticFile,CGI,Compression,Cache,RequestNotifications,Module,Rewrite,WebSocket","Verbose");

// ------------------------------------------------------------
WScript.Echo("...updating WebDAV global settings...");
// ------------------------------------------------------------

var objWebDavGlobalSettings = objAdminManager.GetAdminSection("system.webServer/webdav/globalSettings", strCommitPath);
UpdateWebDavGlobalSettings(objWebDavGlobalSettings.ChildElements.Item("propertyStores").Collection,"webdav_simple_prop","%IIS_BIN%\\webdav_simple_prop.dll","%IIS_BIN%\\webdav_simple_prop.dll");
UpdateWebDavGlobalSettings(objWebDavGlobalSettings.ChildElements.Item("lockStores").Collection,"webdav_simple_lock","%IIS_BIN%\\webdav_simple_lock.dll","%IIS_BIN%\\webdav_simple_lock.dll");

// ------------------------------------------------------------
WScript.Echo("...adding new modules...");
// ------------------------------------------------------------

var objModules = objAdminManager.GetAdminSection("system.webServer/modules", strCommitPath);
AddModule(objModules.Collection,"WebMatrixSupportModule","true","","","IISCertificateMappingAuthenticationModule");
AddModule(objModules.Collection,"DynamicIpRestrictionModule","true","","","IpRestrictionModule");
AddModule(objModules.Collection,"ApplicationInitializationModule","true","","","UrlMappingsModule");
AddModule(objModules.Collection,"WebSocketModule","true","","","ApplicationInitializationModule");
AddModule(objModules.Collection,"ConfigurationValidationModule","true","","","ServiceModel-4.0");

// ------------------------------------------------------------
WScript.Echo("...adding new handlers...");
// ------------------------------------------------------------

var objHandlers = objAdminManager.GetAdminSection("system.webServer/handlers", strCommitPath);
AddHandler(objHandlers.Collection,"vbhtml-ISAPI-4.0_64bit","*.vbhtml","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"vbhtm-ISAPI-4.0_64bit","*.vbhtm","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"cshtml-ISAPI-4.0_64bit","*.cshtml","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"cshtm-ISAPI-4.0_64bit","*.cshtm","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"aspq-ISAPI-4.0_64bit","*.aspq","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"xamlx-ISAPI-4.0_64bit","*.xamlx","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","","",strFirstItem);
AddHandler(objHandlers.Collection,"xoml-ISAPI-4.0_64bit","*.xoml","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","","",strFirstItem);
AddHandler(objHandlers.Collection,"rules-ISAPI-4.0_64bit","*.rules","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","","",strFirstItem);
AddHandler(objHandlers.Collection,"svc-ISAPI-4.0_64bit","*.svc","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","","",strFirstItem);
AddHandler(objHandlers.Collection,"HttpRemotingHandlerFactory-soap-ISAPI-4.0_64bit","*.soap","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"HttpRemotingHandlerFactory-rem-ISAPI-4.0_64bit","*.rem","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"WebServiceHandlerFactory-ISAPI-4.0_64bit","*.asmx","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"SimpleHandlerFactory-ISAPI-4.0_64bit","*.ashx","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"PageHandlerFactory-ISAPI-4.0_64bit","*.aspx","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"AXD-ISAPI-4.0_64bit","*.axd","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","",strFirstItem);
AddHandler(objHandlers.Collection,"svc-ISAPI-4.0_32bit","*.svc","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness32","","","HttpRemotingHandlerFactory-soap-ISAPI-4.0_32bit");
AddHandler(objHandlers.Collection,"rules-ISAPI-4.0_32bit","*.rules","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness32","","","svc-ISAPI-4.0_32bit");
AddHandler(objHandlers.Collection,"xoml-ISAPI-4.0_32bit","*.xoml","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness32","","","rules-ISAPI-4.0_32bit");
AddHandler(objHandlers.Collection,"xamlx-ISAPI-4.0_32bit","*.xamlx","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness32","","","xoml-ISAPI-4.0_32bit");
AddHandler(objHandlers.Collection,"aspq-ISAPI-4.0_32bit","*.aspq","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness32","0","","xamlx-ISAPI-4.0_32bit");
AddHandler(objHandlers.Collection,"ScriptResourceIntegrated-4.0","*ScriptResource.axd","GET,HEAD","","System.Web.Handlers.ScriptResourceHandler, System.Web.Extensions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35","","integratedMode,runtimeVersionv4.0","","","ScriptHandlerFactoryAppServices-Integrated-4.0");
AddHandler(objHandlers.Collection,"TraceHandler-Integrated","trace.axd","GET,HEAD,POST,DEBUG","","System.Web.Handlers.TraceHandler","","integratedMode,runtimeVersionv2.0","","","ISAPI-dll");
AddHandler(objHandlers.Collection,"WebAdminHandler-Integrated","WebAdmin.axd","GET,DEBUG","","System.Web.Handlers.WebAdminHandler","","integratedMode,runtimeVersionv2.0","","","TraceHandler-Integrated");
AddHandler(objHandlers.Collection,"AssemblyResourceLoader-Integrated","WebResource.axd","GET,DEBUG","","System.Web.Handlers.AssemblyResourceLoader","","integratedMode,runtimeVersionv2.0","","","WebAdminHandler-Integrated");
AddHandler(objHandlers.Collection,"PageHandlerFactory-Integrated","*.aspx","GET,HEAD,POST,DEBUG","","System.Web.UI.PageHandlerFactory","","integratedMode,runtimeVersionv2.0","","","AssemblyResourceLoader-Integrated");
AddHandler(objHandlers.Collection,"SimpleHandlerFactory-Integrated","*.ashx","GET,HEAD,POST,DEBUG","","System.Web.UI.SimpleHandlerFactory","","integratedMode,runtimeVersionv2.0","","","PageHandlerFactory-Integrated");
AddHandler(objHandlers.Collection,"svc-ISAPI-2.0-64","*.svc","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","classicMode,runtimeVersionv2.0,bitness64","","","HttpRemotingHandlerFactory-soap-ISAPI-2.0");
AddHandler(objHandlers.Collection,"AXD-ISAPI-2.0-64","*.axd","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","classicMode,runtimeVersionv2.0,bitness64","0","","svc-ISAPI-2.0-64");
AddHandler(objHandlers.Collection,"PageHandlerFactory-ISAPI-2.0-64","*.aspx","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","classicMode,runtimeVersionv2.0,bitness64","0","","AXD-ISAPI-2.0-64");
AddHandler(objHandlers.Collection,"SimpleHandlerFactory-ISAPI-2.0-64","*.ashx","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","classicMode,runtimeVersionv2.0,bitness64","0","","PageHandlerFactory-ISAPI-2.0-64");
AddHandler(objHandlers.Collection,"WebServiceHandlerFactory-ISAPI-2.0-64","*.asmx","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","classicMode,runtimeVersionv2.0,bitness64","0","","SimpleHandlerFactory-ISAPI-2.0-64");
AddHandler(objHandlers.Collection,"HttpRemotingHandlerFactory-rem-ISAPI-2.0-64","*.rem","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","classicMode,runtimeVersionv2.0,bitness64","0","","WebServiceHandlerFactory-ISAPI-2.0-64");
AddHandler(objHandlers.Collection,"HttpRemotingHandlerFactory-soap-ISAPI-2.0-64","*.soap","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","classicMode,runtimeVersionv2.0,bitness64","0","","HttpRemotingHandlerFactory-rem-ISAPI-2.0-64");
AddHandler(objHandlers.Collection,"rules-64-ISAPI-2.0","*.rules","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","classicMode,runtimeVersionv2.0,bitness64","","","HttpRemotingHandlerFactory-soap-ISAPI-2.0-64");
AddHandler(objHandlers.Collection,"xoml-64-ISAPI-2.0","*.xoml","*","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v2.0.50727\\aspnet_isapi.dll","classicMode,runtimeVersionv2.0,bitness64","","","rules-64-ISAPI-2.0");
AddHandler(objHandlers.Collection,"SSINC-stm","*.stm","GET,HEAD,POST","ServerSideIncludeModule","","","","","File","CGI-exe");
AddHandler(objHandlers.Collection,"SSINC-shtm","*.shtm","GET,HEAD,POST","ServerSideIncludeModule","","","","","File","SSINC-stm");
AddHandler(objHandlers.Collection,"SSINC-shtml","*.shtml","GET,HEAD,POST","ServerSideIncludeModule","","","","","File","SSINC-shtm");
AddHandler(objHandlers.Collection,"ExtensionlessUrlHandler-ISAPI-4.0_64bit","*.","GET,HEAD,POST,DEBUG","IsapiModule","","%windir%\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll","classicMode,runtimeVersionv4.0,bitness64","0","","ExtensionlessUrl-ISAPI-4.0_32bit");
AddHandler(objHandlers.Collection,"ExtensionlessUrl-Integrated-4.0","*.","GET,HEAD,POST,DEBUG","","System.Web.Handlers.TransferRequestHandler","","integratedMode,runtimeVersionv4.0","0","","ExtensionlessUrlHandler-ISAPI-4.0_64bit");

// ------------------------------------------------------------
// Commit changes and exit.
// ------------------------------------------------------------

try
{
	objAdminManager.CommitChanges();
}
catch(e)
{
	ErrorMessage(e,"An error occurred trying to commit the changes");
}

WScript.Echo("\nFinished!");
WScript.Quit(0);

// ================================================================================

function AddSection(tmpSectionGroup,tmpSectionName,tmpOverrideModeDefault,tmpAllowDefinition,tmpAllowLocation)
{
	try
	{
		// Retrieve the index within the collection.
		var tmpElementPosition = FindElement2(tmpSectionGroup.sections,tmpSectionName);
		var tmpNewSection = null;
		if (tmpElementPosition == -1)
		{
			tmpNewSection = tmpSectionGroup.Sections.AddSection(tmpSectionName);
		}
		else
		{
			tmpNewSection = tmpSectionGroup.Sections.Item(tmpElementPosition);
		}
		// Add the required attributes.
		tmpNewSection.OverrideModeDefault = tmpOverrideModeDefault;
		tmpNewSection.AllowDefinition = tmpAllowDefinition;
		tmpNewSection.AllowLocation = tmpAllowLocation;
	}
	catch(e)
	{
		ErrorMessage(e,"An error occurred trying to add a section");
	}
}

// ================================================================================

function AddGlobalModule(tmpModuleGroup,tmpModuleName,tmpImage,tmpPreCondition,tmpPreviousModuleName)
{
	try
	{
		// Retrieve the index within the collection.
		var tmpElementPosition = FindElement1(tmpModuleGroup,"add",["name",tmpModuleName]);
		// Delete the item if it already exists.
		if (tmpElementPosition != -1) tmpModuleGroup.DeleteElement(tmpElementPosition);
		// Create a new element
		var tmpNewElement = tmpModuleGroup.CreateNewElement("add");
		// Add the required properties.
		tmpNewElement.Properties.Item("name").Value = tmpModuleName;
		tmpNewElement.Properties.Item("image").Value = tmpImage;
		// Add any optional properties.
		if (tmpPreCondition.length != 0) tmpNewElement.Properties.Item("preCondition").Value = tmpPreCondition;
		// Retrieve the previous index within the collection.
		tmpElementPosition = FindElement3(tmpModuleGroup,tmpPreviousModuleName);
		// Add the new element.
		tmpModuleGroup.AddElement(tmpNewElement, tmpElementPosition + ((tmpElementPosition>0) ? 1 : 0));
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to add a global module");
	}
}

// ================================================================================

function AddIsapiFilter(tmpIsapiFilterCollection,tmpName,tmpPath,tmpEnabled,tmpEnableCache,tmpPreCondition,tmpPreviousFilterName)
{
	try
	{
		// Retrieve the index within the collection.
		var tmpElementPosition = FindElement1(tmpIsapiFilterCollection,"filter",["name",tmpName]);
		// Delete the item if it already exists.
		if (tmpElementPosition != -1) tmpIsapiFilterCollection.DeleteElement(tmpElementPosition);
		// Create a new element
		var tmpNewElement = tmpIsapiFilterCollection.CreateNewElement("filter");
		// Add the required properties.
		tmpNewElement.Properties.Item("name").Value = tmpName;
		tmpNewElement.Properties.Item("path").Value = tmpPath;
		// Add any optional properties.
		if (tmpEnabled.length != 0) tmpNewElement.Properties.Item("enabled").Value = tmpEnabled;
		if (tmpEnableCache.length != 0) tmpNewElement.Properties.Item("enableCache").Value = tmpEnableCache;
		if (tmpPreCondition.length != 0) tmpNewElement.Properties.Item("preCondition").Value = tmpPreCondition;
		// Retrieve the previous index within the collection.
		tmpElementPosition = FindElement3(tmpIsapiFilterCollection,tmpPreviousFilterName);
		// Add the new element.
		tmpIsapiFilterCollection.AddElement(tmpNewElement, tmpElementPosition + ((tmpElementPosition>0) ? 1 : 0));
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to add an ISAPI filter");
	}
}

// ================================================================================

function AddIsapiCgiRestriction(tmpIsapiCgiRestrictionCollection,tmpPath,tmpAllowed,tmpGroupId,tmpDescription,tmpPrevious)
{
	try
	{
		// Retrieve the index within the collection.
		var tmpElementPosition = FindElement1(tmpIsapiCgiRestrictionCollection,"add",["path",tmpPath]);
		// Delete the item if it already exists.
		if (tmpElementPosition != -1) tmpIsapiCgiRestrictionCollection.DeleteElement(tmpElementPosition);
		// Create a new element
		var tmpNewElement = tmpIsapiCgiRestrictionCollection.CreateNewElement("add");
		// Add the required properties.
		tmpNewElement.Properties.Item("path").Value = tmpPath;
		tmpNewElement.Properties.Item("allowed").Value = tmpAllowed;
		// Add any optional properties.
		if (tmpGroupId.length != 0) tmpNewElement.Properties.Item("groupId").Value = tmpGroupId;
		if (tmpDescription.length != 0) tmpNewElement.Properties.Item("description").Value = tmpDescription;
		// Retrieve the previous index within the collection.
		tmpElementPosition = FindElement3(tmpIsapiCgiRestrictionCollection,tmpPrevious);
		// Add the new element.
		tmpIsapiCgiRestrictionCollection.AddElement(tmpNewElement, tmpElementPosition + ((tmpElementPosition>0) ? 1 : 0));
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to add an ISAPI/CGI restriction");
	}
}

// ================================================================================

function AddMimeMap(tmpStaticContentCollection,tmpFileExtension,tmpMimeType)
{
	try
	{
		// Retrieve the index within the collection.
		var tmpElementPosition = FindElement1(tmpStaticContentCollection,"mimeMap",["fileExtension",tmpFileExtension]);
		// Delete the item if it already exists.
		if (tmpElementPosition != -1) tmpStaticContentCollection.DeleteElement(tmpElementPosition);
		// Create a new element
		var tmpNewElement = tmpStaticContentCollection.CreateNewElement("mimeMap");
		// Add the required properties.
		tmpNewElement.Properties.Item("fileExtension").Value = tmpFileExtension;
		tmpNewElement.Properties.Item("mimeType").Value = tmpMimeType;
		// Add the new element.
		tmpStaticContentCollection.AddElement(tmpNewElement, -1);
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to add a MIME map");
	}
}

// ================================================================================

function AddTraceProviderDefinitions(tmpTraceProviderDefinitionCollection,tmpParent,tmpName,tmpValue)
{
	try
	{
		// Retrieve the index within the collection.
		var tmpElementPosition1 = FindElement1(tmpTraceProviderDefinitionCollection,"add",["name",tmpParent]);
		if (tmpElementPosition1 != -1)
		{
			var objWwwServerDefinitions = tmpTraceProviderDefinitionCollection.Item(tmpElementPosition1).ChildElements.Item(0).Collection;
			// Retrieve the index within the collection.
			var tmpElementPosition2 = FindElement1(objWwwServerDefinitions,"add",["name",tmpName]);
			// Delete the item if it already exists.
			if (tmpElementPosition2 != -1) objWwwServerDefinitions.DeleteElement(tmpElementPosition2);
			// Create a new element.
			var tmpNewElement = objWwwServerDefinitions.CreateNewElement("add");
			// Add the required properties.
			tmpNewElement.Properties.Item("name").Value = tmpName;
			tmpNewElement.Properties.Item("value").Value = tmpValue;
			// Add the new element.
			objWwwServerDefinitions.AddElement(tmpNewElement, -1);
		}
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to add a trace provider definition");
	}
}

// ================================================================================

function UpdateTraceAreas(tmpTraceAreasCollection,tmpProvider,tmpAreas,tmpVerbosity)
{
	try
	{
		// Retrieve the index within the collection.
		var objTraceAreas = tmpTraceAreasCollection.Item(0).ChildElements.Item(0).Collection;
		// Retrieve the index within the collection.
		var tmpElementPosition = FindElement1(objTraceAreas,"add",["provider",tmpProvider]);
		// Delete the item if it already exists.
		if (tmpElementPosition != -1) objTraceAreas.DeleteElement(tmpElementPosition);
		// Create a new element.
		var tmpNewElement = objTraceAreas.CreateNewElement("add");
		// Add the required properties.
		tmpNewElement.Properties.Item("provider").Value = tmpProvider;
		tmpNewElement.Properties.Item("areas").Value = tmpAreas;
		tmpNewElement.Properties.Item("verbosity").Value = tmpVerbosity;
		// Add the new element.
		objTraceAreas.AddElement(tmpNewElement, -1);
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to update the trace areas");
	}
}

// ================================================================================

function UpdateWebDavGlobalSettings(tmpWebDavStore,tmpName,tmpImage,tmpImage32)
{
	try
	{
		// Retrieve the index within the collection.
		var tmpElementPosition = FindElement1(tmpWebDavStore,"add",["name",tmpName]);
		// Delete the item if it already exists.
		if (tmpElementPosition != -1) tmpWebDavStore.DeleteElement(tmpElementPosition);
		// Create a new element.
		var tmpNewElement = tmpWebDavStore.CreateNewElement("add")
		// Add the required properties.
		tmpNewElement.Properties.Item("name").Value = tmpName;
		tmpNewElement.Properties.Item("image").Value = tmpImage;
		tmpNewElement.Properties.Item("image32").Value = tmpImage32;
		// Add the new element.
		tmpWebDavStore.AddElement(tmpNewElement, -1);
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to update the WebDAV settings");
	}
}

// ================================================================================

function AddModule(tmpModuleGroup,tmpModuleName,tmpLockItem,tmpType,tmpPreCondition,tmpPreviousModuleName)
{
	try
	{
		// Retrieve the index within the collection.
		var tmpElementPosition = FindElement1(tmpModuleGroup,"add",["name",tmpModuleName]);
		// Delete the item if it already exists.
		if (tmpElementPosition != -1) tmpModuleGroup.DeleteElement(tmpElementPosition);
		// Create a new element.
		var tmpNewElement = tmpModuleGroup.CreateNewElement("add");
		// Add the required properties.
		tmpNewElement.Properties.Item("name").Value = tmpModuleName;
		// Add any optional properties.
		if (tmpLockItem.length != 0) tmpNewElement.SetMetadata("lockItem", (tmpLockItem.toLowerCase() == "true") ? true : false );
		if (tmpType.length != 0) tmpNewElement.Properties.Item("type").Value = tmpType;
		if (tmpPreCondition.length != 0) tmpNewElement.Properties.Item("preCondition").Value = tmpPreCondition;
		// Retrieve the previous index within the collection.
		tmpElementPosition = FindElement3(tmpModuleGroup,tmpPreviousModuleName);
		// Add the new element.
		tmpModuleGroup.AddElement(tmpNewElement, tmpElementPosition + ((tmpElementPosition>0) ? 1 : 0));
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to add a module");
	}
}

// ================================================================================

function AddHandler(tmpHandlerCollection,tmpName,tmpPath,tmpVerb,tmpModules,tmpType,tmpScriptProcessor,tmpPreCondition,tmpPesponseBufferLimit,tmpResourceType,tmpPrevious)
{
	try
	{
		// Retrieve the index within the collection.
		var tmpElementPosition = FindElement1(tmpHandlerCollection,"add",["name",tmpName]);
		// Delete the item if it already exists.
		if (tmpElementPosition != -1) tmpHandlerCollection.DeleteElement(tmpElementPosition);
		// Create a new element.
		var tmpNewElement = tmpHandlerCollection.CreateNewElement("add");
		// Add the required properties.
		tmpNewElement.Properties.Item("name").Value = tmpName;
		tmpNewElement.Properties.Item("verb").Value = tmpVerb;
		tmpNewElement.Properties.Item("path").Value = tmpPath;
		// Add any optional properties.
		if (tmpType.length != 0) tmpNewElement.Properties.Item("type").Value = tmpType;
		if (tmpModules.length != 0) tmpNewElement.Properties.Item("modules").Value = tmpModules;
		if (tmpScriptProcessor.length != 0) tmpNewElement.Properties.Item("scriptProcessor").Value = tmpScriptProcessor;
		if (tmpPreCondition.length != 0) tmpNewElement.Properties.Item("preCondition").Value = tmpPreCondition;
		if (tmpPesponseBufferLimit.length != 0) tmpNewElement.Properties.Item("responseBufferLimit").Value = tmpPesponseBufferLimit;
		if (tmpResourceType.length != 0) tmpNewElement.Properties.Item("resourceType").Value = tmpResourceType;
		// Retrieve the previous index within the collection.
		tmpElementPosition = FindElement3(tmpHandlerCollection,tmpPrevious);
		// Add the new element.
		tmpHandlerCollection.AddElement(tmpNewElement, tmpElementPosition + ((tmpElementPosition>0) ? 1 : 0));
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to add a handler");
	}
}

// ================================================================================

function PadNumber(tmpNumber)
{
	return (tmpNumber < 10) ? ("0" + tmpNumber.toString()) : tmpNumber.toString();
}

// ================================================================================

function ErrorMessage(tmpError,tmpMessage)
{
	WScript.Echo("\n" + tmpMessage + ":\n" + tmpError.description);
	WScript.Quit(tmpError.number);
}

// ================================================================================

function GetAdminManager()
{
	try
	{
		var tmpVersionManager = WScript.CreateObject("Microsoft.IIS.VersionManager");
		var tmpVersionObject = tmpVersionManager.GetVersionObject("10.0", 1);
		var tmpAdminManager = tmpVersionObject.CreateObjectFromProgId("Microsoft.ApplicationHost.WritableAdminManager");
		return tmpAdminManager;
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to obtain the Admin Manager");
	}
}

// ================================================================================

function GetUserDirectory()
{
	try
	{
		var tmpVersionManager = WScript.CreateObject("Microsoft.IIS.VersionManager");
		var tmpVersionObject = tmpVersionManager.GetVersionObject("10.0", 1);
		var tmpUserData = tmpVersionObject.GetPropertyValue("userInstanceHelper")
		var tmpUserDirectory = tmpUserData.IISDirectory;
		if (tmpUserDirectory.length > 0) return tmpUserDirectory;
		throw("The User Directory cannot be determined.");
	}
	catch(e)
	{
		ErrorMessage(e,"The following error occurred trying to obtain the User Directory");
	}
}

// ================================================================================

function FindSectionGroup(tmpParentSectionGroup,tmpName)
{
	try
	{
		// Retrieve the index within the sectionGroup.
		var tmpElementPosition = FindElement2(tmpParentSectionGroup,tmpName);
		// Fail completely if we can't retrive the index.
		if (tmpElementPosition == -1) throw("Cannot retrieve index for '" & tmpName & "'.");
		return tmpParentSectionGroup.Item(tmpElementPosition);
	}
	catch(e)
	{
		ErrorMessage(e,"An error occurred trying to add a section group");
	}
}

// ================================================================================

function FindElement1(tmpCollection, tmpElementTagName, tmpValuesArray)
{
   for (var tmpCount1 = 0; tmpCount1 < tmpCollection.Count; ++tmpCount1)
   {
      var tmpElement = tmpCollection.Item(tmpCount1);
      if (tmpElement.Name == tmpElementTagName)
      {
         var tmpMatches = true;
         for (var tmpCount2 = 0; tmpCount2 < tmpValuesArray.length; tmpCount2 += 2)
         {
            var tmpProperty = tmpElement.GetPropertyByName(tmpValuesArray[tmpCount2]);
            var tmpValue = tmpProperty.Value;
            if (tmpValue != null) tmpValue = tmpValue.toString();
            if (tmpValue != tmpValuesArray[tmpCount2 + 1])
            {
               tmpMatches = false;
               break;
            }
         }
         if (tmpMatches) return tmpCount1;
      }
   }
   return -1;
}

// ================================================================================

function FindElement2(tmpCollection,tmpName)
{
	for (var tmpCount = 0; tmpCount < tmpCollection.Count; ++tmpCount)
	{
		var tmpElement = tmpCollection.Item(tmpCount);
		if (tmpElement.Name == tmpName)
		{
			return tmpCount;
		}
	}
   return -1;
}

// ================================================================================

function FindElement3(tmpCollection,tmpName)
{
	if ((tmpName.length ==0) || (tmpName.toLowerCase() == strLastItem.toLowerCase())) return -1;
	if ((tmpName.length ==0) || (tmpName.toLowerCase() == strFirstItem.toLowerCase())) return 0;	
	return FindElement1(tmpCollection,"add",["name",tmpName]);
}

// SIG // Begin signature block
// SIG // MIInvQYJKoZIhvcNAQcCoIInrjCCJ6oCAQExDzANBglg
// SIG // hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
// SIG // BgEEAYI3AgEeMCQCAQEEEBDgyQbOONQRoqMAEEvTUJAC
// SIG // AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
// SIG // qkLf6hUIUQIUdckZ0Q9IsyYTk/q7ULZ8ux3vr03b6zOg
// SIG // gg12MIIF9DCCA9ygAwIBAgITMwAAA68wQA5Mo00FQQAA
// SIG // AAADrzANBgkqhkiG9w0BAQsFADB+MQswCQYDVQQGEwJV
// SIG // UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
// SIG // UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
// SIG // cmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBT
// SIG // aWduaW5nIFBDQSAyMDExMB4XDTIzMTExNjE5MDkwMFoX
// SIG // DTI0MTExNDE5MDkwMFowdDELMAkGA1UEBhMCVVMxEzAR
// SIG // BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
// SIG // bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
// SIG // bjEeMBwGA1UEAxMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
// SIG // MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
// SIG // zkvLNa2un9GBrYNDoRGkGv7d0PqtTBB4ViYakFbjuWpm
// SIG // F0KcvDAzzaCWJPhVgIXjz+S8cHEoHuWnp/n+UOljT3eh
// SIG // A8Rs6Lb1aTYub3tB/e0txewv2sQ3yscjYdtTBtFvEm9L
// SIG // 8Yv76K3Cxzi/Yvrdg+sr7w8y5RHn1Am0Ff8xggY1xpWC
// SIG // XFI+kQM18njQDcUqSlwBnexYfqHBhzz6YXA/S0EziYBu
// SIG // 2O2mM7R6gSyYkEOHgIGTVOGnOvvC5xBgC4KNcnQuQSRL
// SIG // iUI2CmzU8vefR6ykruyzt1rNMPI8OqWHQtSDKXU5JNqb
// SIG // k4GNjwzcwbSzOHrxuxWHq91l/vLdVDGDUwIDAQABo4IB
// SIG // czCCAW8wHwYDVR0lBBgwFgYKKwYBBAGCN0wIAQYIKwYB
// SIG // BQUHAwMwHQYDVR0OBBYEFEcccTTyBDxkjvJKs/m4AgEF
// SIG // hl7BMEUGA1UdEQQ+MDykOjA4MR4wHAYDVQQLExVNaWNy
// SIG // b3NvZnQgQ29ycG9yYXRpb24xFjAUBgNVBAUTDTIzMDAx
// SIG // Mis1MDE4MjYwHwYDVR0jBBgwFoAUSG5k5VAF04KqFzc3
// SIG // IrVtqMp1ApUwVAYDVR0fBE0wSzBJoEegRYZDaHR0cDov
// SIG // L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jcmwvTWlj
// SIG // Q29kU2lnUENBMjAxMV8yMDExLTA3LTA4LmNybDBhBggr
// SIG // BgEFBQcBAQRVMFMwUQYIKwYBBQUHMAKGRWh0dHA6Ly93
// SIG // d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2VydHMvTWlj
// SIG // Q29kU2lnUENBMjAxMV8yMDExLTA3LTA4LmNydDAMBgNV
// SIG // HRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4ICAQCEsRbf
// SIG // 80dn60xTweOWHZoWaQdpzSaDqIvqpYHE5ZzuEMJWDdcP
// SIG // 72MGw8v6BSaJQ+a+hTCXdERnIBDPKvU4ENjgu4EBJocH
// SIG // lSe8riiZUAR+z+z4OUYqoFd3EqJyfjjOJBR2z94Dy4ss
// SIG // 7LEkHUbj2NZiFqBoPYu2OGQvEk+1oaUsnNKZ7Nl7FHtV
// SIG // 7CI2lHBru83e4IPe3glIi0XVZJT5qV6Gx/QhAFmpEVBj
// SIG // SAmDdgII4UUwuI9yiX6jJFNOEek6MoeP06LMJtbqA3Bq
// SIG // +ZWmJ033F97uVpyaiS4bj3vFI/ZBgDnMqNDtZjcA2vi4
// SIG // RRMweggd9vsHyTLpn6+nXoLy03vMeebq0C3k44pgUIEu
// SIG // PQUlJIRTe6IrN3GcjaZ6zHGuQGWgu6SyO9r7qkrEpS2p
// SIG // RjnGZjx2RmCamdAWnDdu+DmfNEPAddYjaJJ7PTnd+PGz
// SIG // G+WeH4ocWgVnm5fJFhItjj70CJjgHqt57e1FiQcyWCwB
// SIG // hKX2rGgN2UICHBF3Q/rsKOspjMw2OlGphTn2KmFl5J7c
// SIG // Qxru54A9roClLnHGCiSUYos/iwFHI/dAVXEh0S0KKfTf
// SIG // M6AC6/9bCbsD61QLcRzRIElvgCgaiMWFjOBL99pemoEl
// SIG // AHsyzG6uX93fMfas09N9YzA0/rFAKAsNDOcFbQlEHKiD
// SIG // T7mI20tVoCcmSIhJATCCB3owggVioAMCAQICCmEOkNIA
// SIG // AAAAAAMwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYT
// SIG // AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
// SIG // EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
// SIG // cG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290
// SIG // IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDExMB4XDTEx
// SIG // MDcwODIwNTkwOVoXDTI2MDcwODIxMDkwOVowfjELMAkG
// SIG // A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
// SIG // BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
// SIG // dCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9zb2Z0
// SIG // IENvZGUgU2lnbmluZyBQQ0EgMjAxMTCCAiIwDQYJKoZI
// SIG // hvcNAQEBBQADggIPADCCAgoCggIBAKvw+nIQHC6t2G6q
// SIG // ghBNNLrytlghn0IbKmvpWlCquAY4GgRJun/DDB7dN2vG
// SIG // EtgL8DjCmQawyDnVARQxQtOJDXlkh36UYCRsr55JnOlo
// SIG // XtLfm1OyCizDr9mpK656Ca/XllnKYBoF6WZ26DJSJhIv
// SIG // 56sIUM+zRLdd2MQuA3WraPPLbfM6XKEW9Ea64DhkrG5k
// SIG // NXimoGMPLdNAk/jj3gcN1Vx5pUkp5w2+oBN3vpQ97/vj
// SIG // K1oQH01WKKJ6cuASOrdJXtjt7UORg9l7snuGG9k+sYxd
// SIG // 6IlPhBryoS9Z5JA7La4zWMW3Pv4y07MDPbGyr5I4ftKd
// SIG // gCz1TlaRITUlwzluZH9TupwPrRkjhMv0ugOGjfdf8NBS
// SIG // v4yUh7zAIXQlXxgotswnKDglmDlKNs98sZKuHCOnqWbs
// SIG // YR9q4ShJnV+I4iVd0yFLPlLEtVc/JAPw0XpbL9Uj43Bd
// SIG // D1FGd7P4AOG8rAKCX9vAFbO9G9RVS+c5oQ/pI0m8GLhE
// SIG // fEXkwcNyeuBy5yTfv0aZxe/CHFfbg43sTUkwp6uO3+xb
// SIG // n6/83bBm4sGXgXvt1u1L50kppxMopqd9Z4DmimJ4X7Iv
// SIG // hNdXnFy/dygo8e1twyiPLI9AN0/B4YVEicQJTMXUpUMv
// SIG // dJX3bvh4IFgsE11glZo+TzOE2rCIF96eTvSWsLxGoGyY
// SIG // 0uDWiIwLAgMBAAGjggHtMIIB6TAQBgkrBgEEAYI3FQEE
// SIG // AwIBADAdBgNVHQ4EFgQUSG5k5VAF04KqFzc3IrVtqMp1
// SIG // ApUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYD
// SIG // VR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0j
// SIG // BBgwFoAUci06AjGQQ7kUBU7h6qfHMdEjiTQwWgYDVR0f
// SIG // BFMwUTBPoE2gS4ZJaHR0cDovL2NybC5taWNyb3NvZnQu
// SIG // Y29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0
// SIG // MjAxMV8yMDExXzAzXzIyLmNybDBeBggrBgEFBQcBAQRS
// SIG // MFAwTgYIKwYBBQUHMAKGQmh0dHA6Ly93d3cubWljcm9z
// SIG // b2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0MjAx
// SIG // MV8yMDExXzAzXzIyLmNydDCBnwYDVR0gBIGXMIGUMIGR
// SIG // BgkrBgEEAYI3LgMwgYMwPwYIKwYBBQUHAgEWM2h0dHA6
// SIG // Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvZG9jcy9w
// SIG // cmltYXJ5Y3BzLmh0bTBABggrBgEFBQcCAjA0HjIgHQBM
// SIG // AGUAZwBhAGwAXwBwAG8AbABpAGMAeQBfAHMAdABhAHQA
// SIG // ZQBtAGUAbgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEA
// SIG // Z/KGpZjgVHkaLtPYdGcimwuWEeFjkplCln3SeQyQwWVf
// SIG // Liw++MNy0W2D/r4/6ArKO79HqaPzadtjvyI1pZddZYSQ
// SIG // fYtGUFXYDJJ80hpLHPM8QotS0LD9a+M+By4pm+Y9G6XU
// SIG // tR13lDni6WTJRD14eiPzE32mkHSDjfTLJgJGKsKKELuk
// SIG // qQUMm+1o+mgulaAqPyprWEljHwlpblqYluSD9MCP80Yr
// SIG // 3vw70L01724lruWvJ+3Q3fMOr5kol5hNDj0L8giJ1h/D
// SIG // Mhji8MUtzluetEk5CsYKwsatruWy2dsViFFFWDgycSca
// SIG // f7H0J/jeLDogaZiyWYlobm+nt3TDQAUGpgEqKD6CPxNN
// SIG // ZgvAs0314Y9/HG8VfUWnduVAKmWjw11SYobDHWM2l4bf
// SIG // 2vP48hahmifhzaWX0O5dY0HjWwechz4GdwbRBrF1HxS+
// SIG // YWG18NzGGwS+30HHDiju3mUv7Jf2oVyW2ADWoUa9WfOX
// SIG // pQlLSBCZgB/QACnFsZulP0V3HjXG0qKin3p6IvpIlR+r
// SIG // +0cjgPWe+L9rt0uX4ut1eBrs6jeZeRhL/9azI2h15q/6
// SIG // /IvrC4DqaTuv/DDtBEyO3991bWORPdGdVk5Pv4BXIqF4
// SIG // ETIheu9BCrE/+6jMpF3BoYibV3FWTkhFwELJm3ZbCoBI
// SIG // a/15n8G9bW1qyVJzEw16UM0xghmfMIIZmwIBATCBlTB+
// SIG // MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
// SIG // bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
// SIG // cm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNy
// SIG // b3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExAhMzAAAD
// SIG // rzBADkyjTQVBAAAAAAOvMA0GCWCGSAFlAwQCAQUAoIGu
// SIG // MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisG
// SIG // AQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3
// SIG // DQEJBDEiBCC93OYXDMwxoCLGRcyKtUWK3ABu4NRsVow/
// SIG // I5oZqs/G7jBCBgorBgEEAYI3AgEMMTQwMqAUgBIATQBp
// SIG // AGMAcgBvAHMAbwBmAHShGoAYaHR0cDovL3d3dy5taWNy
// SIG // b3NvZnQuY29tMA0GCSqGSIb3DQEBAQUABIIBAHeadBUC
// SIG // rz5qW/ad4LJk7MeyXJ53zKSjE+4VVJwv1roIrE6CR9D+
// SIG // oJv9qbZnXRD4tzS/A8IdP78FmOHYtRyvMWSs8p2YCKuC
// SIG // TF4bsnkk/MXGZOXqSgZoqHH5DC7W+pVXF6LFunoT/upF
// SIG // H6Al/7o3l1IKvIOlQ0AsUN/v7sPwAxcpajz/zVzutIZO
// SIG // UN84YIRy196DSsPaDb29zsbUXDV4lR+7QxVDq8Rhefo4
// SIG // MR+xesxDX11ZAffE23fifSJt1IklPlP2NShDne85fPCY
// SIG // 9FEpLrVeMlrSazHrgV1AL3afeO9oglHgm6zs9OQfpR+R
// SIG // XniTSJbKu5QqtypLUW4Khsohh3qhghcpMIIXJQYKKwYB
// SIG // BAGCNwMDATGCFxUwghcRBgkqhkiG9w0BBwKgghcCMIIW
// SIG // /gIBAzEPMA0GCWCGSAFlAwQCAQUAMIIBWQYLKoZIhvcN
// SIG // AQkQAQSgggFIBIIBRDCCAUACAQEGCisGAQQBhFkKAwEw
// SIG // MTANBglghkgBZQMEAgEFAAQgCNmRmsqo7OdhjjgfQyJ+
// SIG // gABudYmjNiy9ELu7vNaONTwCBmXWCMYuhxgTMjAyNDAz
// SIG // MDYyMTA3NDcuOTc0WjAEgAIB9KCB2KSB1TCB0jELMAkG
// SIG // A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
// SIG // BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
// SIG // dCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0
// SIG // IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYD
// SIG // VQQLEx1UaGFsZXMgVFNTIEVTTjoxNzlFLTRCQjAtODI0
// SIG // NjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
// SIG // U2VydmljZaCCEXgwggcnMIIFD6ADAgECAhMzAAAB4NT8
// SIG // HxMVH35dAAEAAAHgMA0GCSqGSIb3DQEBCwUAMHwxCzAJ
// SIG // BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
// SIG // DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
// SIG // ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29m
// SIG // dCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTIzMTAxMjE5
// SIG // MDcxOVoXDTI1MDExMDE5MDcxOVowgdIxCzAJBgNVBAYT
// SIG // AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
// SIG // EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
// SIG // cG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVs
// SIG // YW5kIE9wZXJhdGlvbnMgTGltaXRlZDEmMCQGA1UECxMd
// SIG // VGhhbGVzIFRTUyBFU046MTc5RS00QkIwLTgyNDYxJTAj
// SIG // BgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZp
// SIG // Y2UwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
// SIG // AQCsh5zzocW70QE5xo2/+n7gYYd2S86LQMQIHS2mf85E
// SIG // RVHXkis8jbd7aqKzCuxg73F3SrPqiDFG73p5R/sOd7LD
// SIG // 2uq2D++tGbhawAa37Hq39JBWsjV1c8E+42qyThI5xTAa
// SIG // fsovrsENk5ybsXM3HhuRQx6yCOrBehfO/ZT+snWNAQWZ
// SIG // Gfbd/Xv7LzUYngOYFJ7/2HDP2yDGP0GJnfRdAfnmxWIv
// SIG // jx+AJF2oTZBYCvOTiGkawxr4Z8Tmv+cxi+zooou/iff0
// SIG // B5HSRpX50X20N0FzP+f7pgTihuCaBWNZ4meUVR+T09Pr
// SIG // go8HKoU2571LXyvjfsgdm/axGb6dk7+GcGMxHfQPVbGD
// SIG // LmYgkm2hTJO+y8FW5JaZ8OGh1iVyZBGJib8UW3E4RPBU
// SIG // MjqFZErinOTlmdvljP4+dKG5QNLQlOdwGrr1DmUaEAYf
// SIG // PZxyvpuaTlyl3WDCfnHri2BfIecv3Fy0DDpqiyc+ZezC
// SIG // 6hsFNMx1fjBDvC9RaNsxBEOIi+AV/GJJyl6JxxkGnEgm
// SIG // i2aLdpMiVUbBUsZ9D5T7x1adGHbAjM3XosPYwGeyvbNV
// SIG // sbGRhAayv6G4qV+rsYxKclAPZm1T5Y5W90eDFiNBNsSP
// SIG // zTOheAHPAnmsd2Fi0/mlgmXqoiDC8cslmYPotSmPGRMz
// SIG // HjUyghCOcBdcMaq+k9fzEKPvLQIDAQABo4IBSTCCAUUw
// SIG // HQYDVR0OBBYEFHBeFz9unVfvErrKANV10Nkw0pnSMB8G
// SIG // A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
// SIG // A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9z
// SIG // b2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUyMFRp
// SIG // bWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggr
// SIG // BgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93
// SIG // d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2VydHMvTWlj
// SIG // cm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAo
// SIG // MSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAww
// SIG // CgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqG
// SIG // SIb3DQEBCwUAA4ICAQDAE84OkfwNJXTuzKhsQ9VSY4uc
// SIG // lQNYR29B3NGI7b+1pMUPIsH35bpV+VLOuLQ9/tzU9SZK
// SIG // YVs2gFn9sCnQMN+UcbUBtYjjdxxGdF9t53XuCoP1n28e
// SIG // axB5GfW8yp0f9jeQNevsP9aW8Cc3X0XJyU93C8msK/5G
// SIG // IzFnetzj9Bpau9LmuFlBPz6OaVO60EW1hKEKM2NuIQKj
// SIG // nMLkXJugm9CQXkzgnkQZ7RCoIynqeKUWkLe2/b7rE/e1
// SIG // niXH2laLJpj7bGbGsIJ6SI2wWuebR37pNLw5GbWyF41O
// SIG // Jq+XZ7PXZ2pwXQUtj2Nzd4SHwjxDrM6rsBy5H5BWf/W8
// SIG // cPP3kSZXbaLpB6NemnxPwKj/7JphiYeWUdKZoFukHF/u
// SIG // ta3YuZAyU8whWqDMmM1EtEhG8qw2f6dijrigGDZ4JY4j
// SIG // pZZXLdLiVc9moH3Mxo47CotgEtVml7zoYGTZhsONkhQd
// SIG // ampaGvCmrsfUNhxyxPIHnv+a4Dp8fc0m31VHOyHETaHa
// SIG // uke7/kc/j+lyrToMgqlv/q4T5qf5+xatgRk0ZHMv/4Zk
// SIG // t9qeqsoJa9iuDqCQyV8RbOpcHPA/OqpVHho1MqO4VcuV
// SIG // b8gPstJhpxALgPObbDnFD5c8FhebL/geX89+Tlt1+EqZ
// SIG // OUojbpZyxUTzOVwrEh6r3GwvEd6sI9sNXrz4WcQ7jTCC
// SIG // B3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUw
// SIG // DQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMw
// SIG // EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
// SIG // b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
// SIG // b24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRp
// SIG // ZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTIxMDkzMDE4
// SIG // MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMC
// SIG // VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
// SIG // B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
// SIG // b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUt
// SIG // U3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUA
// SIG // A4ICDwAwggIKAoICAQDk4aZM57RyIQt5osvXJHm9DtWC
// SIG // 0/3unAcH0qlsTnXIyjVX9gF/bErg4r25PhdgM/9cT8dm
// SIG // 95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNE
// SIG // t6aORmsHFPPFdvWGUNzBRMhxXFExN6AKOG6N7dcP2CZT
// SIG // fDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6GnszrYBbfowQ
// SIG // HJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5
// SIG // LFGc6XBpDco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVV
// SIG // mG1oO5pGve2krnopN6zL64NF50ZuyjLVwIYwXE8s4mKy
// SIG // zbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpG
// SIG // dc3EXzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2
// SIG // TPYrbqgSUei/BQOj0XOmTTd0lBw0gg/wEPK3Rxjtp+iZ
// SIG // fD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1q
// SIG // GFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSL
// SIG // W6CmgyFdXzB0kZSU2LlQ+QuJYfM2BjUYhEfb3BvR/bLU
// SIG // HMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PAPBXb
// SIG // GjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQID
// SIG // AQABo4IB3TCCAdkwEgYJKwYBBAGCNxUBBAUCAwEAATAj
// SIG // BgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxGNSnPEP8v
// SIG // BO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1Gely
// SIG // MFwGA1UdIARVMFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYI
// SIG // KwYBBQUHAgEWM2h0dHA6Ly93d3cubWljcm9zb2Z0LmNv
// SIG // bS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNV
// SIG // HSUEDDAKBggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4K
// SIG // AFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/
// SIG // BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2U
// SIG // kFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8v
// SIG // Y3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0
// SIG // cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
// SIG // KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8v
// SIG // d3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jv
// SIG // b0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG9w0B
// SIG // AQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwU
// SIG // tj5OR2R4sQaTlz0xM7U518JxNj/aZGx80HU5bbsPMeTC
// SIG // j/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmCVgADsAW+
// SIG // iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhT
// SIG // dSRXud2f8449xvNo32X2pFaq95W2KFUn0CS9QKC/GbYS
// SIG // EhFdPSfgQJY4rPf5KYnDvBewVIVCs/wMnosZiefwC2qB
// SIG // woEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0
// SIG // DLzskYDSPeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxy
// SIG // bxCrdTDFNLB62FD+CljdQDzHVG2dY3RILLFORy3BFARx
// SIG // v2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+k
// SIG // KNxnGSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2
// SIG // tVdUCbFpAUR+fKFhbHP+CrvsQWY9af3LwUFJfn6Tvsv4
// SIG // O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokL
// SIG // jzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTm
// SIG // dHRbatGePu1+oDEzfbzL6Xu/OHBE0ZDxyKs6ijoIYn/Z
// SIG // cGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggLUMIIC
// SIG // PQIBATCCAQChgdikgdUwgdIxCzAJBgNVBAYTAlVTMRMw
// SIG // EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
// SIG // b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
// SIG // b24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9w
// SIG // ZXJhdGlvbnMgTGltaXRlZDEmMCQGA1UECxMdVGhhbGVz
// SIG // IFRTUyBFU046MTc5RS00QkIwLTgyNDYxJTAjBgNVBAMT
// SIG // HE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoB
// SIG // ATAHBgUrDgMCGgMVAG3z0dXwV+h8WH8j8fM2MyVOXyEM
// SIG // oIGDMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
// SIG // Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
// SIG // BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
// SIG // A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
// SIG // MTAwDQYJKoZIhvcNAQEFBQACBQDpkvmTMCIYDzIwMjQw
// SIG // MzA2MjIxNzU1WhgPMjAyNDAzMDcyMjE3NTVaMHQwOgYK
// SIG // KwYBBAGEWQoEATEsMCowCgIFAOmS+ZMCAQAwBwIBAAIC
// SIG // HmYwBwIBAAICETswCgIFAOmUSxMCAQAwNgYKKwYBBAGE
// SIG // WQoEAjEoMCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAweh
// SIG // IKEKMAgCAQACAwGGoDANBgkqhkiG9w0BAQUFAAOBgQBN
// SIG // yil3s6vvFl52GCgAgKL12mwXu/Q3uhk03CW8TDFy42ev
// SIG // L6UJVeCNQuopFKyEQ9y3wqaQ9Fyz6mzYsliZk8HbqEN8
// SIG // ReZ6DWsYD4KUHSvcokdu0quQwVk4iLdtjJwfkk/GngNB
// SIG // qUai9bv5pnUrcN/SfIu8FxI3109ElbQ5wSQvPjGCBA0w
// SIG // ggQJAgEBMIGTMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
// SIG // EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4w
// SIG // HAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAk
// SIG // BgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAy
// SIG // MDEwAhMzAAAB4NT8HxMVH35dAAEAAAHgMA0GCWCGSAFl
// SIG // AwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcN
// SIG // AQkQAQQwLwYJKoZIhvcNAQkEMSIEIA8iNlbQ0GSQB1rN
// SIG // GS8eBI3DUUGauJ2+U25J7Aq5bp1wMIH6BgsqhkiG9w0B
// SIG // CRACLzGB6jCB5zCB5DCBvQQg4+5Sv/I55W04z73O+wwg
// SIG // km+E2QKWPZyZucIbCv9pCsEwgZgwgYCkfjB8MQswCQYD
// SIG // VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
// SIG // A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
// SIG // IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
// SIG // VGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAeDU/B8TFR9+
// SIG // XQABAAAB4DAiBCCtXrDGf55fzF0ZYD/NLQPAnV3wP6rf
// SIG // Ekd6xfGIC/CExjANBgkqhkiG9w0BAQsFAASCAgBypf3E
// SIG // kAio18bwIujd2jXIrbh6cyvY8HX4dly2o2mSA5z4iy7x
// SIG // bui0ql9Ydd9LQarXQjHGlOurAI8y771zqAl9JzdQU5ID
// SIG // DzlGjGIUKKGz/5ZPrn9yRA1Er/vH/xuOCcNfSXryZ8vH
// SIG // uGy1hXExmB8IYg8ufsYUVOUhEaEV+STBtkwAyfmhUQ4A
// SIG // FftJiNm9WEZmjVOU82Dc86RgzE1PHifi9AOpl/w3wSfc
// SIG // tNYR0V/BL/0GmsHhen4/5IbNl9xpSluoFYQd4Q1BHx6f
// SIG // dNI/JagttkSiXDWZ3Yo7R4NXLHs/7fKAkWCBWP+v7Omn
// SIG // bUw5S84o07K46KEpdv+h2E9jzW5th4Gd5slZqg48k6z2
// SIG // 68SyNCz/I6x0peWvBrpST+VJMR4/GazNsfB54/NCBbM5
// SIG // o1ZpYF2S4KiSdiVIYuRGwV8Sq8Ofv+qrKuUGbzUFJFeG
// SIG // Yz/f7xLuUNsTbqH6v3lCvdO2U480k5BW0cRK8zA1A2yY
// SIG // FXxszyAqKI+ssQPfViJVMiH0b2RBlRMAhey+cEri/5Ku
// SIG // uVIyw6Mn/d3ybkJmFjkjtoJINCvIPCkzNCzEJrVjprkr
// SIG // +SKTBCI4nNEkQ94fItOJ8ojqATE1Bt6gMzQ4tbeOrFkv
// SIG // 9HbUOdIypS1Emu2ROlfYhEBCTrPAm6/3xxjF754JPNlv
// SIG // ekW71cF/MeCK/mrA4Q==
// SIG // End signature block
