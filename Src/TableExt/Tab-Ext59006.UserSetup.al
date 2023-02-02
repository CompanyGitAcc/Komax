tableextension 59006 "TP User Setup" extends "User Setup"
{
    fields
    {

        //++BC190.Deposit1.00.ALF
        field(59000; "Cashier"; Boolean)
        {
            Caption = 'Cashier'; //控制收付款单的现金管理
        }
        field(59001; "Finance Controller"; Boolean)
        {
            Caption = 'Finance Controller'; // 应收应付控制，是否允许编辑客户卡片和订单预付款管理
        }
        //--BC190.Deposit1.00.ALF
        field(59002; "User Name"; Text[100])
        {
            Caption = 'User Name';
            FieldClass = FlowField;
            CalcFormula = lookup(User."Full Name" where("User Name" = field("User ID")));
        }
        field(59003; "Batch Rel. Or Del. Docs."; Boolean)
        {
            Caption = 'Batch Release Or Delete Documents'; // 允许批量删除单据
        }
        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================  

        // field(50000; "Can Edit Credit Limit"; Boolean)
        // {
        //     Caption = 'Can Edit Credit Limit';
        // }
        // field(50001; "HR Module Operator"; Boolean)
        // {
        //     Caption = 'HR Module Operator';
        // }
        // field(50002; "Allow Invoice On Order"; Boolean)
        // {
        //     Caption = 'Allow Invoice On Order';
        // }
        // field(50003; "User Name"; Code[250])
        // {
        //     Caption = 'User Name';
        //     FieldClass = FlowField;
        //     CalcFormula = Lookup(Employee."Search Name" WHERE("No." = FIELD("User ID")));
        // }
        // field(50004; "Allow Change Vendor Block"; Boolean)
        // {
        //     Caption = 'Allow Change Vendor Block';
        // }
        // field(50005; "Price Permission"; Boolean)
        // {
        //     Caption = 'Price Permission';
        // }
        // field(50006; "Block Vendor"; Boolean)
        // {
        //     Caption = 'Block Vendor';
        // }
    }

}

