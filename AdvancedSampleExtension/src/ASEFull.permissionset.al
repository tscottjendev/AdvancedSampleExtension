permissionset 50100 "ASE Full"
{
    Assignable = true;
    Permissions =
        table "ASE Activation Code Info." = X,
        tabledata "ASE Activation Code Info." = RIMD,
        table "ASE Cust. Rewards Mgt. Setup" = X,
        tabledata "ASE Cust. Rewards Mgt. Setup" = RIMD,
        table "ASE Reward Level" = X,
        tabledata "ASE Reward Level" = RIMD,

        codeunit "ASE Customer Rewards Ext. Mgt." = X,
        codeunit "ASE Cust. Rewards Install" = X,

        page "ASE Customer Rewards Wizard" = X,
        page "ASE Rewards Level List" = X;
}