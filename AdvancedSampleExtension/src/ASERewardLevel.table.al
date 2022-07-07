table 50100 "ASE Reward Level"
{
    Caption = 'Reward Level';
    DrillDownPageId = "ASE Rewards Level List";
    LookupPageId = "ASE Rewards Level List";

    fields
    {
        field(1; Level; Text[20])
        {
            Caption = 'Level';
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(2; "Minimum Reward Points"; Integer)
        {
            Caption = 'Minimum Reward Points';
            MinValue = 0;
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                ASERewardLevel: Record "ASE Reward Level";
                tempPoints: Integer;
            begin
                tempPoints := "Minimum Reward Points";
                ASERewardLevel.SetRange("Minimum Reward Points", tempPoints);
                if not ASERewardLevel.IsEmpty() then
                    Error('Minimum Reward Points must be unique');
            end;
        }
    }

    keys
    {
        key(PK; Level)
        {
            Clustered = true;
        }
        key("Minimum Reward Points"; "Minimum Reward Points") { }
    }

    trigger OnInsert();
    begin

        Validate("Minimum Reward Points");
    end;

    trigger OnModify();
    begin
        Validate("Minimum Reward Points");
    end;
}