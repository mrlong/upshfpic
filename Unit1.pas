unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ADODB, Grids, DBGrids,
  MongoDBEx,_bson,GridFS,MongoDB;

type
  TForm1 = class(TForm)
    btn1: TBitBtn;
    ds1: TDataSource;
    dbgrd1: TDBGrid;
    con1: TADOConnection;
    tbl1: TADOTable;
    lbl1: TLabel;
    chk1: TCheckBox;
    btn2: TBitBtn;
    btn3: TButton;
    dlgOpen1: TOpenDialog;
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
    //写入文件到mongodb内
    function WriteFileEx( AFileName, AID: string) :Integer;

  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

const
  gc_connstr = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';

{$R *.dfm}

{
   结构的设计


}

procedure TForm1.btn1Click(Sender: TObject);
var
  mypicdir : string;
  i,j,c ,mycount : Integer;
  myname,mystr,mystr2 : string;
  mongo  : TMongoConnection;
  coll   : TMongoCollection;
  bson   : TBSONDocument;
  item_k,item_x,item_c,item_l,item_z,mycurritem   : TBSONArrayItem;
  item_author   : TBSONArrayItem;
  myzidir : string; //存放图字的地方
  mysl   : TStringList;
  myfilename_b,myfilename_s : string; //上传的文件名
  myzi : string;
begin
  mypicdir := ExtractFileDir(system.ParamStr(0)) + '\pic';

  mongo := TMongoConnection.Create('112.124.59.236','27017','shfpic');
  coll := mongo.GetCollection('shfpics');

  //112.124.59.236
  i := 1;
  mycount := tbl1.RecordCount;
  tbl1.First;
  while not tbl1.Eof do
  begin
    myzi := '字';// tbl1.FieldByName('zi').AsString;
    myzidir := mypicdir + '\' + myzi;
    if not DirectoryExists(myzidir) then
    begin
      i := i + 1;
      if chk1.Checked then Break;
      lbl1.Caption := Format('%d/%d',[i,mycount]);
      Application.ProcessMessages;
      tbl1.Next;
      Continue;
    end;

    if {tbl1.FieldByName('pic').AsBoolean} true then
    begin
      bson   := TBSONDocument.Create;
      bson.Values['zi'] := TBSONStringItem.Create(UTF8Encode(myzi));

      {
      楷书: k
      草书: c
      行书: x
      隶书：l
      篆书: z
      }
      item_k   := TBSONArrayItem.Create;
      item_c   := TBSONArrayItem.Create;
      item_x   := TBSONArrayItem.Create;
      item_l   := TBSONArrayItem.Create;
      item_z   := TBSONArrayItem.Create;


      mysl   := TStringList.Create;
      mysl.LoadFromFile(Format('%s\%s.txt',[myzidir,myzi]));
      c := 0;
      for j:=0 to (mysl.Count div 2) -1 do
      begin
        (*
          kb褚遂良={69B88B51-992D-4F57-9325-F6DB3FB10F77}_褚遂良.png
          ks褚遂良={F27CA401-1E72-424C-A802-624292B90C3E}__褚遂良.png
        *)

        mystr := mysl.Strings[c+j];
        mystr2 := mysl.Strings[c+j+1];
        c := j +1;

        if (Length(mystr) > 0) and (mystr[1]='k') then
        begin
          mycurritem := item_k;
          mystr := Copy(mystr,2,MaxInt);
        end
        else if (Length(mystr) > 0) and (mystr[1]='c') then
        begin
          mycurritem := item_c;
          mystr := Copy(mystr,2,MaxInt);
        end
        else if (Length(mystr) > 0) and (mystr[1]='x') then
        begin
          mycurritem := item_x;
          mystr := Copy(mystr,2,MaxInt);
        end
        else if  (Length(mystr) > 0) and (mystr[1]='l') then
        begin
          mycurritem := item_l;
          mystr := Copy(mystr,2,MaxInt);
        end
        else if (Length(mystr) > 0) and (mystr[1]='z') then
        begin
          mycurritem := item_z;
          mystr := Copy(mystr,2,MaxInt);
        end
        else
          mycurritem := nil;

        if Assigned(mycurritem) then
        begin
          myname := Copy(mystr,2,pos('=',mystr)-1-1); //作者名称

          //上传文件
          item_author   := TBSONArrayItem.Create;
          item_author.Items[item_author.Data.Count+1]  := TBSONStringItem.Create(UTF8Encode(myname));
          item_author.Items[item_author.Data.Count+1]  := TBSONStringItem.Create('l');
          item_author.Items[item_author.Data.Count+1]  := TBSONStringItem.Create('s');
          //mycurritem
          //ShowMessage(item_author.ToString);
          mycurritem.WriteItem(mycurritem.Data.Count+1,item_author);
        end;
        
      end;

      bson.Values['k'] := item_k;
      bson.Values['c'] := item_c;
      bson.Values['x'] := item_x;
      bson.Values['l'] := item_l;
      bson.Values['z'] := item_z;


      coll.save(bson); //保存
    end;

    if chk1.Checked then Break;
    lbl1.Caption := Format('%d/%d',[i,mycount]);
    i := i + 1;
    Application.ProcessMessages;
    tbl1.Next;
  end;

end;

procedure TForm1.FormShow(Sender: TObject);
var
  mystr : string;
begin
  //
  mystr := Format(gc_connstr,['./xhzd.mdb']);
  con1.Close;
  con1.ConnectionString := mystr;
  con1.Open;
  tbl1.Open;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  bson              : TBSONDocument;
  item              : TBSONArrayItem;
begin
  bson := TBSONDocument.Create;
  item := TBSONArrayItem.Create;
  item.Items[3222] := TBSONStringItem.Create( 'awesome' );
  item.Items[1] := TBSONDoubleItem.Create( 5.05 );
  item.Items[2] := TBSONIntItem.Create( 1986 );
  bson.Values['BSON'] := item;
  bson.SaveToFile( ExtractFilePath( Application.ExeName ) + 'hello.bson' );
  bson.LoadFromFile(ExtractFilePath( Application.ExeName ) + 'hello.bson' );
  ShowMessage(bson.ToString);
  bson.Free;
end;

function TForm1.WriteFileEx(AFileName, AID: string): Integer;
var
  myGfs :TGridFS;
  myMongo :TMongo;
  myid : string;
  myHost : string;
  mydbName : string;

  function DisConnectDBEx(var AMongo :TMongo ;var AGfs :tGridFs):Integer;
  begin
    Result := 0;
    AMongo.disconnect;
    FreeAndNil(AGfs);
    FreeAndNil(AMongo);
  end;

  function ConnectDBEx(var AMongo :TMongo ;var AGfs :tGridFs ;APrefix :string) :Integer;
  begin
    Result := 99;
    if Assigned(AMongo) then
    begin
      if DisConnectDBEx(AMongo,AGfs) <>0 then
        Exit;
    end;

    AMongo := TMongo.Create(myHost);
    if AMongo.isConnected() then
    begin
      AMongo.setTimeout(0);
      AGfs := TGridFS.Create(AMongo,mydbName,APrefix);
      Result := 0;
    end
    else begin
      case AMongo.getErr of
        1: Result := 4;
        2: Result := 5;
        4: Result := 7;
        else
          Result := 1;
      end
    end;
  end;

begin
  Result := 99;
  myMongo := nil;
  myGfs  := nil;
  myHost := '112.124.59.236'; //
  mydbName := 'shfpic';
  

  if ConnectDBEx(myMongo,myGfs,'picture') <> 0 then  //链接数据库Collection。
  begin
    Result := 2 ;
    Exit;
  end;

  if Assigned(myMongo) and (myMongo.isConnected) then
  begin
    myid := AID;
    myid := LowerCase(myid);
    if myGfs.storeFile(AFileName,PChar(myid)) then
      Result := 0
    else
      Result := 3;
  end
  else
    Result := 2;
  DisConnectDBEx(myMongo,myGfs);
end;


procedure TForm1.btn3Click(Sender: TObject);
var
  myfilename : string;
  myname : string;
begin
  if dlgOpen1.Execute then
  begin
    myfilename := dlgOpen1.FileName;
    myname := 
    if WriteFileEx(myfilename,'11')=0 then
    begin
      ShowMessage('ok');
    end;
    
  end;
end;

end.
