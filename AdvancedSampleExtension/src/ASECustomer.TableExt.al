tableextension 50100 "ASE Customer" extends Customer
{
    fields
    {
        field(50100; "ASE Reward Points"; Integer)
        {
            Caption = 'Reward Points';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
    }
}