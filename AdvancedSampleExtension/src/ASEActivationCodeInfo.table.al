table 50101 "ASE Activation Code Info."
{
    Caption = 'Activation Code Information';

    fields
    {
        field(1; ActivationCode; Text[14])
        {
            Caption = 'Activation Code';
            Description = 'Activation code used to activate Customer Rewards';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(2; "Date Activated"; Date)
        {
            Caption = 'Date Activated';
            Description = 'Date Customer Rewards was activated';
            DataClassification = CustomerContent;
        }

        field(3; "Expiration Date"; Date)
        {
            Caption = 'Expriation Date';
            Description = 'Date Customer Rewards activation expires';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; ActivationCode)
        {
            Clustered = true;
        }
    }
}