pageextension 50100 "ASE Customer Card" extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field("ASE RewardLevel"; RewardLevel)
            {
                ApplicationArea = All;
                Caption = 'Reward Level';
                Description = 'Reward level of the customer.';
                ToolTip = 'Specifies the level of reward that the customer has at this point.';
                Editable = false;
            }

            field("ASE RewardPoints"; Rec."ASE Reward Points")
            {
                ApplicationArea = All;
                Caption = 'Reward Points';
                Description = 'Reward points accrued by customer';
                ToolTip = 'Specifies the total number of points that the customer has at this point.';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        ASECustomerRewardsExtMgt: Codeunit "ASE Customer Rewards Ext. Mgt.";
    begin
        // Get the reward level associated with reward points 
        RewardLevel := ASECustomerRewardsExtMgt.GetRewardLevel(Rec."ASE Reward Points");
    end;

    var
        RewardLevel: Text;
}