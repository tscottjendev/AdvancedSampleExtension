page 50101 "ASE Rewards Level List"
{
    Caption = 'Rewards Level List';
    PageType = List;
    ContextSensitiveHelpPage = 'sales-rewards';
    SourceTable = "ASE Reward Level";
    SourceTableView = sorting("Minimum Reward Points") order(ascending);
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Level; Rec.Level)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the level of reward that the customer has at this point.';
                }

                field("Minimum Reward Points"; Rec."Minimum Reward Points")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of points that customers must have to reach this level.';
                }
            }
        }
    }

    trigger OnOpenPage();
    begin

        if (not ASECustomerRewardsExtMgt.IsCustomerRewardsActivated()) then
            Error(NotActivatedTxt);
    end;

    var
        ASECustomerRewardsExtMgt: Codeunit "ASE Customer Rewards Ext. Mgt.";
        NotActivatedTxt: Label 'Customer Rewards is not activated';
}