table 50102 "ASE Cust. Rewards Mgt. Setup"
{
    Caption = 'Customer Rewards Management Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }

        field(2; "Ext. Mgt. Codeunit ID"; Integer)
        {
            Caption = 'Extension Management Codeunit ID';
            TableRelation = "CodeUnit Metadata".ID;
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}