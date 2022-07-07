codeunit 50100 "ASE Cust. Rewards Install"
{
    // Customer Rewards Install Logic 
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    begin
        SetDefaultCustomerRewardsExtMgtCodeunit();
    end;

    procedure SetDefaultCustomerRewardsExtMgtCodeunit();
    var
        ASECustRewardsMgtSetup: Record "ASE Cust. Rewards Mgt. Setup";
    begin
        ASECustRewardsMgtSetup.DeleteAll();
        ASECustRewardsMgtSetup.Init();
        // Default Customer Rewards Ext. Mgt codeunit to use for handling events  
        ASECustRewardsMgtSetup."Ext. Mgt. Codeunit ID" := Codeunit::"ASE Customer Rewards Ext. Mgt.";
        ASECustRewardsMgtSetup.Insert();
    end;
}