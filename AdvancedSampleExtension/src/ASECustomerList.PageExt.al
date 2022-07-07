pageextension 50101 "ASE Customer List" extends "Customer List"
{
    actions
    {
        addfirst("&Customer")
        {
            action("ASE Reward Levels")
            {
                Caption = 'Reward Levels';
                ApplicationArea = All;
                Image = CustomerRating;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the list of reward levels.';


                trigger OnAction();
                begin
                    if ASECustomerRewardsExtMgt.IsCustomerRewardsActivated() then
                        ASECustomerRewardsExtMgt.OpenRewardsLevelPage()
                    else
                        ASECustomerRewardsExtMgt.OpenCustomerRewardsWizard();
                end;
            }
        }
    }

    var
        ASECustomerRewardsExtMgt: Codeunit "ASE Customer Rewards Ext. Mgt.";
}