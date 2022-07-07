codeunit 50101 "ASE Customer Rewards Ext. Mgt."
{
    var
        DummySuccessResponseTxt: Label '{"ActivationResponse": "Success"}', Locked = true;
        NoRewardlevelTxt: Label 'NONE';

    // Determines if the extension is activated 
    procedure IsCustomerRewardsActivated(): Boolean;
    var
        ASEActivationCodeInfo: Record "ASE Activation Code Info.";
    begin
        if not ASEActivationCodeInfo.FindFirst() then
            exit(false);

        if (ASEActivationCodeInfo."Date Activated" <= Today) and (Today <= ASEActivationCodeInfo."Expiration Date") then
            exit(true);
        exit(false);
    end;

    // Opens the Customer Rewards Assisted Setup Guide 
    procedure OpenCustomerRewardsWizard();
    var
        ASECustomerRewardsWizard: Page "ASE Customer Rewards Wizard";
    begin
        ASECustomerRewardsWizard.RunModal();
    end;

    // Opens the Reward Level page 
    procedure OpenRewardsLevelPage();
    var
        ASERewardsLevelList: Page "ASE Rewards Level List";
    begin
        ASERewardsLevelList.Run();
    end;

    // Determines the correponding reward level and returns it 
    procedure GetRewardLevel(RewardPoints: Integer) RewardLevelTxt: Text;
    var
        ASERewardLevel: Record "ASE Reward Level";
        MinRewardLevelPoints: Integer;
    begin
        RewardLevelTxt := NoRewardlevelTxt;

        if ASERewardLevel.IsEmpty() then
            exit;
        ASERewardLevel.SetRange("Minimum Reward Points", 0, RewardPoints);
        ASERewardLevel.SetCurrentKey("Minimum Reward Points"); // sorted in ascending order 

        if not ASERewardLevel.FindFirst() then
            exit;
        MinRewardLevelPoints := ASERewardLevel."Minimum Reward Points";

        if RewardPoints >= MinRewardLevelPoints then begin
            ASERewardLevel.Reset();
            ASERewardLevel.SetRange("Minimum Reward Points", MinRewardLevelPoints, RewardPoints);
            ASERewardLevel.SetCurrentKey("Minimum Reward Points"); // sorted in ascending order 
            ASERewardLevel.FindLast();
            RewardLevelTxt := ASERewardLevel.Level;
        end;
    end;

    // Activates Customer Rewards if activation code is validated successfully  
    procedure ActivateCustomerRewards(ActivationCode: Text): Boolean;
    var
        ASEActivationCodeInfo: Record "ASE Activation Code Info.";
    begin
        // raise event 
        OnGetActivationCodeStatusFromServer(ActivationCode);
        exit(ASEActivationCodeInfo.Get(ActivationCode));
    end;

    // publishes event 
    [IntegrationEvent(false, false)]
    procedure OnGetActivationCodeStatusFromServer(ActivationCode: Text);
    begin
    end;

    // Subscribes to OnGetActivationCodeStatusFromServer event and handles it when the event is raised 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ASE Customer Rewards Ext. Mgt.", 'OnGetActivationCodeStatusFromServer', '', false, false)]
    local procedure OnGetActivationCodeStatusFromServerSubscriber(ActivationCode: Text);
    var
        ActivationCodeInfo: Record "ASE Activation Code Info.";
        ResponseText: Text;
        Result: JsonToken;
        JsonRepsonse: JsonToken;
    begin
        if not CanHandle() then
            exit; // use the mock 

        // Get response from external service and update activation code information if successful 
        if (GetHttpResponse(ActivationCode, ResponseText)) then begin
            JsonRepsonse.ReadFrom(ResponseText);

            if (JsonRepsonse.SelectToken('ActivationResponse', Result)) then
                if (Result.AsValue().AsText() = 'Success') then begin

                    if (ActivationCodeInfo.FindFirst()) then
                        ActivationCodeInfo.Delete();

                    ActivationCodeInfo.Init();
                    ActivationCodeInfo.ActivationCode := CopyStr(ActivationCode, 1, MaxStrLen(ActivationCodeInfo.ActivationCode));
                    ActivationCodeInfo."Date Activated" := Today;
                    ActivationCodeInfo."Expiration Date" := CalcDate('<1Y>', Today);
                    ActivationCodeInfo.Insert();

                end;
        end;
    end;

    // Helper method to make calls to a service to validate activation code 
    local procedure GetHttpResponse(ActivationCode: Text; var ResponseText: Text): Boolean;
    begin
        // You will typically make external calls / http requests to your service to validate the activation code 
        // here but for the sample extension we simply return a successful dummy response 
        if ActivationCode = '' then
            exit(false);

        ResponseText := DummySuccessResponseTxt;
        exit(true);
    end;

    // Subcribes to the OnAfterReleaseSalesDoc event and increases reward points for the sell to customer in posted sales order 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDocSubscriber(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; LinesWereModified: Boolean);
    var
        Customer: Record Customer;
    begin
        if SalesHeader.Status <> SalesHeader.Status::Released then
            exit;

        Customer.Get(SalesHeader."Sell-to Customer No.");
        Customer."ASE Reward Points" += 1; // Add a point for each new sales order 
        Customer.Modify();
    end;

    // Checks if the current codeunit is allowed to handle Customer Rewards Activation requests rather than a mock. 
    local procedure CanHandle(): Boolean;
    var
        ASECustRewardsMgtSetup: Record "ASE Cust. Rewards Mgt. Setup";
    begin
        if ASECustRewardsMgtSetup.Get() then
            exit(ASECustRewardsMgtSetup."Ext. Mgt. Codeunit ID" = Codeunit::"ASE Customer Rewards Ext. Mgt.");
        exit(false);
    end;
}