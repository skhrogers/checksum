/**
 *  MIT License
 *
 *  Copyright (c) 2021 Huawei Device Co., Ltd.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import fileio from '@ohos.fileio';
import { Checksum, Options } from '@ohos/checksum';
import * as EntryAbility from "../entryability/EntryAbility"
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct Index {
  @State mgs: string = this.getResourceString($r('app.string.empty'))
  @State path: string = ""
  @State mArguments: Options = new Options();

  getResourceString(res: Resource) {
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Scroll() {
      }

      Text(this.getResourceString($r('app.string.Display_result')) + this.mgs)
        .width(400)
        .height(100)
        .fontSize(16)
        .fontColor(Color.Green)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Clip })
        .padding(20)

      Button($r('app.string.SHA1_DShaw')).width(200).height(50).onClick((event: ClickEvent) => {
        this.mArguments.algorithm = "sha1"
        let mChecksum: Checksum = new Checksum()
        this.mgs = mChecksum.checksum("dshaw", this.mArguments)
      }).margin(20)

      Button($r('app.string.MD5_DShaw')).width(200).height(50).onClick((event: ClickEvent) => {
        this.mArguments.algorithm = "md5"
        let mChecksum: Checksum = new Checksum()
        this.mgs = mChecksum.checksum("dshaw", this.mArguments)
      }).margin(20)
      Button($r('app.string.Create_File')).width(200).height(50).onClick((event: ClickEvent) => {
        this.writeFiles();
      }).margin(20)
      Button($r('app.string.SHA1_Test')).width(200).height(50).onClick((event: ClickEvent) => {
        this.mArguments.algorithm = "sha1"
        let mChecksum: Checksum = new Checksum()
        mChecksum.checksumFile(this.path + "/Test.txt", this.mArguments, (err: BusinessError, data: string) => {
          this.mgs = "sha1 : " + data
        })
      }).margin(20)

      Button($r('app.string.Md5_Test')).width(200).height(50).onClick((event: ClickEvent) => {
        this.mArguments.algorithm = "md5"
        let mChecksum: Checksum = new Checksum()
        mChecksum.checksumFile(this.path + "/Test.txt", this.mArguments, (err: BusinessError, data: string) => {
          this.mgs = "md5 :" + data
        })
      }).margin(20)
    }
    .width('100%')
    .height('100%')
  }

  private writeFiles() {
    this.path = EntryAbility.ChecksumPath
    console.log("写入成功" + EntryAbility.ChecksumPath)
    try {
      let fd = fileio.openSync(EntryAbility.ChecksumPath + "/Test.txt", 0o100 | 0o102, 0o666)
      fileio.ftruncateSync(fd)
      fileio.writeSync(fd, "dshaw")
      fileio.fsyncSync(fd)
      fileio.closeSync(fd)
      console.log("写入成功")
    } catch (e) {
      console.info('writeFile', 'Failed to writeFile for ' + e);
    }
  }
}