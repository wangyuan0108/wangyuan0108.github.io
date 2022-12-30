---
title: git中版本回退的各种方式
categories: WEB前端
copyright: true
date: 2022-12-30 10:57:42
tags:
---
前言
--

`git`作为一款版本控制工具，其最核心的功能就是版本回退，没有之一。熟悉`git`版本回退的操作能够让你真真正正地放开手脚去开发，不用小心翼翼，怕一不小心删除了不该删除的文件。本节除了介绍版本回退的内容之外，还会介绍`stash`的使用。

一、版本回退
------

在`git`中永远有后悔药可吃，总是可以回到**版本库**的某一个时刻，这就叫做**版本回退**；

![image-20200406144058526](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301100124.image)

如上图所示：当前`master`分支指针指向`D`，通过版本回退可以使`master`指向`C`、`B`或`A`。进行版本回退的命令大体上有三种：`reset`、`revert`和`checkout`。下面就来一一讲解：

### Ⅰ.`git reset`

#### 1.参数

`reset`命令可以添加很多参数，常用的有`--mixed`、`--soft`和`--hard`三种。下图为一次完整提交的四个阶段：

![image-20200412192613526](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301100185.image)

三个参数大体上的区别为：

*   `--mixed`：为默认值，等同于`git reset`。作用为：将文件回退到**工作区**，此时会保留**工作区**中的文件，但会丢弃**暂存区**中的文件；
*   `--soft`：作用为：将文件回退到**暂存区**，此时会保留**工作区**和**暂存区**中的文件；
*   `--hard`：作用为：将文件回退到**修改前**，此时会丢弃**工作区**和**暂存区**中的文件；

下面就来详细地讲解它们的使用方法：

首先在`master`分支进行四次提交，每次提交在`test.txt`中添加一行文本信息：

![image-20200406164503683](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301100462.image)

##### `--mixed`

该参数为默认值，作用为：将文件回退到工作区中：如下图所示，将`test.txt`文件回退一次提交：

![image-20200412194811197](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301100251.image)

可以看到第四次提交对`test.txt`的修改操作被回退到了工作区当中，并且保留了工作区中第四次提交对`test.txt`所做的修改，所以工作区中的`test.txt`文件内容与回退前一致。

##### `--soft`

该参数的作用为：将文件回退到暂存区中：如下图所示，将`test.txt`文件回退一次提交：

![image-20200412195321082](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301100965.image)

可以看到第四次提交对`test.txt`的修改操作被回退到了暂存区当中，并且保留了工作区和暂存区中第四次提交对`test.txt`所做的修改，所以，工作区中的文件内容与回退前一致。

##### `--hard`

该参数的作用为：将文件回退到修改前：如下图所示，将`test.txt`文件回退一次提交：

![image-20200412205112201](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301101322.image)

可以看到`test.txt`直接回到了进行第四次提交前，此时删除了工作区和暂存区中第四次提交对`test.txt`所做的修改。所以，工作区变得干净了，`test.txt`文件内容回退到刚完成第三次提交时。

#### 2.写法

为了方便演示`reset`的各种使用方法，下面的指令都采用`--hard`参数。

##### `git reset --hard HEAD^`

**该命令的作用为回退一次提交：**

![image-20200406164628192](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301101863.image)

回退后的状态为：

![image-20200406164713774](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301101780.image)

可以看到，该方法会同时改变了`HEAD`和`master`指针的指向；

##### `git reset --hard HEAD^^`

**该命令的作用为回退两次提交：**

![image-20200406170323254](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301101325.image)

回退后的状态为：

![image-20200406170352024](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301101015.image)

同样，使用`--hard`参数回退，工作区是干净的；可以看到，该方法也会同时改变`HEAD`和`master`指针的指向；

##### `git reset --hard HEAD~n`

**该命令的作用为回退`n`次提交：**

![image-20200406203027868](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301101546.image)

可以看到使用了`--hard`参数，回退结果符合预期，并且该方法也会同步修改`HEAD`和分支`master`指针的指向。

**注意：该方式只能向前回退，不能向后回退**。

> 上述命令中的`HEAD`可以更换为分支名，比如`master`：
> 
> ```
> git reset --hard master~n
> 
> ```
> 
> 该命令表示将`master`分支回退`n`次提交。由于`HEAD`始终指向当前分支，所以使用分支名和使用`HEAD`效果是一样的。

##### `git reset --hard commit_id`

\*\*该指令的作用为回退到指定的`commit id`的提交版本；**由于`commit id`是不会重复的，一般只需要写前几（`6`）位就可以识别出来。通过`commit id`的回退方式**既可以向前回退，也可以向后回退。\*\*如下所示，从`1st commit`往后回退到`4th commit`，其中`4th commit`的`commit id = bdb373...`。

为了熟悉该指令，我们分两种方式进行回退：使用`--hard`参数与使用默认参数。

*   **使用`--hard`参数**
    
    ![image-20200406193422130](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301102731.image)
    
    从图中可以看出：通过第四次提交的`commit_id: bdb373`顺利地从第一次提交向后回退到了第四次提交，并且工作区干净。该方法也同时修改了`HEAD`和分支`master`的指向，具体过程为：
    
    ![image-20200414171228274](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301102485.image)
    
*   **使用默认参数**
    
    ![image-20200406193005200](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301102009.image)
    
    可以看到切换回了`4th commit`，但是工作区的`test.txt`文件并没有变化；这是因为，在`4th -> 1st`的过程中，需要在工作区中删除`test.txt`文件中的`2nd line、3rd line、4th line`。通过默认参数`--mixed`，将`4th commit`对文件的修改回退到了工作区当中，如下图所示：
    
    ![image-20200406202451310](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301102806.image)
    
    这个过程丢弃了**暂存区**中对文件的删除操作，但是保留了**工作区**中对文件的删除操作。所以，工作区中的`test.txt`文件仍然处于删除了三行内容的状态。
    
    此时只需要将修改操作从阶段`1`移动到修改前的阶段`0`，即可将文件恢复到修改前的状态，并清空工作区。可以采用`git restore test.txt`实现：
    
    ![image-20200406202716247](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301102098.image)
    

### Ⅱ.`git revert`

`revert`是回滚，重做的意思。不同于`reset`直接通过改变分支指向来进行版本回退，并且不产生新的提交；`revert`是通过额外创建一次提交，来取消分支上指定的某次提交的方式，来实现版本回退的。如下图所示，假如想要重做提交`B`，重做前与重做后的状态为：

![image-20200413234440432](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301102830.image)

所谓重做提交`B`，指的是在新建的提交`B'`中取消提交`B`中所做的一切操作。也就是说`revert`的思想为：通过创建一个新提交来取消不要的提交。所以，提交数会增加。

#### 1.参数

`git`同样为`revert`提供了许多参数，常用的有以下三种。为了演示它们的作用，首先需要设置对应的测试环境：在`dev`分支上进行四次提交，每次提交都为`test.txt`添加一行内容：

![image-20200414000404304](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301102855.image)

##### `-e`

`-e`参数是`--edit`的缩写，为`revert`指令的默认参数，即`git revert -e`等同于`git revert`。该参数的作用为在重做过程中，新建一次提交的同时编辑提交信息。比如通过以下命令重做上述的`dev2`提交：

```
git revert f4a95

```

执行该指令后会创建一次新的提交来取消提交`dev2`所做的一切操作，并且会进入`vim`编辑器，编辑新提交的提交注释：  
![image-20200414115052089](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301103107.image)

如下图所示，提交`dev2`为文件`test.txt`添加的`dev2`文本被取消了，并且`dev`分支上多了一次提交：

![image-20200414114945783](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301103439.image)

##### `--no-edit`

该参数的作用为不编辑由于`revert`重做，所新增提交的注释信息。如下图所示，通过：

```
git revert --no-edit f4a95b

```

重做提交`dev2`的过程中，并不会进入`vim`编辑器编辑新增提交的注释信息，而是采用默认的注释信息：`Revert "dev2"`：

![image-20200414114748865](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301103973.image)

##### `-n`

`-n`参数是`--no-commit`的简写形式，作用为对`revert`重做某次提交时所产生的修改，不进行提交，也就是不会新增一次提交；

如下图所示，这是`revert`指令通过新建提交`B'`来取消提交`B`的过程，分为`0~4`个阶段。不添加`-n`参数时，`revert`指令会产生一次额外提交`B'`，此时处于下图中的第`3`阶段。而使用`-n`参数时，虽然`revert`指令也会通过新建提交`B'`来重做提交`B`。但是，此时还处于生成提交`B'`的过程，还没有完全生成提交`B'`，也就是处于下图中的第`2`阶段。

![image-20200414002942670](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301103671.image)

这种做法的好处是，允许我们干涉`revert`重做过程，手动进行提交。如下图所示，通过：

```
git revert -n f4a95

```

重做提交`dev2`的过程中，手动暂停了重做过程。虽然提交`dev2`对`test.txt`所做的修改已被撤销，但是这一重做操作还未进行提交：

![image-20200414120436217](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301103050.image)

这样我们既可以修改重做过程中不满意的地方，也可以随意添加注释。修改完后，通过手动提交的方式，完成重做（`REVERTING`）操作：

![image-20200414121147251](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301104376.image)

#### 2.写法

`revert`指令也有多种写法，下面介绍主要的几种。为了方便演示，下列指令都采用默认参数`-e`手动编辑每次新增提交的注释信息。

##### `git revert commit_id`

这是最常用的写法，通过`commit_id`精准地选择想要重做的提交。分两种情况：

*   \*\*情况一：\*\*重做最新一次提交，不会发生冲突。
    
    例如：通过以下指令，重做`dev`分支上最新的一次提交`dev2`：
    
    ```
    git revert f4a95b
    
    ```
    
    首先进入`vim`编辑器编辑新增提交的注释信息：
    
    ![image-20200414135326937](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301104770.image)
    
    随后完成重做操作，如下图所示；可见提交`dev2`给`test.txt`添加的`dev2`内容被删除了，并且多出一次提交，说明重做成功：
    
    ![image-20200414140040443](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301104069.image)
    
*   \*\*情况二：\*\*重做非最新一次提交，会发生冲突。
    
    例如：通过以下指令，重做`dev`分支上的第三次提交`dev1`：
    
    ```
    git revert dbde45
    
    ```
    
    会出现合并冲突：
    
    ![image-20200414140502098](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301104296.image)
    
    使用`git mergetool`指令，通过`vim`编辑器的工具`vimdiff`显示冲突文件`test.txt`：
    
    ![image-20200414140645448](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301104090.image)
    
    回车进入`vim`编辑器界面，解决冲突：
    
    ![image-20200414141354304](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301105846.image)
    
    解决冲突之后，手动进行一次提交，完成`revert`过程：
    
    ![image-20200414142323103](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301105788.image)
    
*   **为什么会出现冲突？**
    
    通过上面的例子不难看出，`revert`操作生成的**新提交其实是通过两次提交合并而成**的。如下图所示：
    
    ![image-20200414143430837](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301105796.image)
    
    *   首先，将被重做的提交`dev1`的前一次提交`2nd`复制一份，即图中的`2nd'`；
    *   然后，将它与当前分支的最新提交`dev2`进行合并，由此生成`revert`操作新增的提交；
    
    知道了`revert`操作新增的提交的由来后，就不难解释为什么会出现合并冲突了，如下图所示：
    
    ![image-20200414144109389](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301105276.image)
    
    合并的两次提交中，文件`test.txt`的内容不一样。`git`不知道以哪个版本为准，自然会导致自动合并失败，需要手动合并。
    

##### `git revert HEAD`

该指令的作用为重做所在分支的最新一次提交，并且不会发生冲突：

![image-20200414150640086](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301105655.image)

##### `git revert HEAD^`

该指令的作用为重做所在分支的倒数第二次提交，会发生冲突，需要手动合并，完成重做操作：

![image-20200414151002143](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301105229.image)

##### `git revert HEAD^^`

该指令的作用为重做所在分支的倒数第三次提交，会发生冲突，需要手动合并，完成重做操作：

![image-20200414180953703](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301106374.image)

##### `git revert HEAD~n`

该指令的作用为重做所在分支的倒数第`n+1`次提交，会发生冲突，需要手动合并，完成重做操作。过程与上述一致，这里就不再赘述了。

> \*\*总结：\*\*常用`git revert commit_id`这种方式。

#### 3.撤销`revert`操作

思路很简单，再次通过`revert`操作取消上一次的`revert`操作（即所谓"负负得正"）。

操作前，`dev`分支上的提交记录和`test.txt`文件内容如下：

![image-20200414153206034](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301106645.image)

通过：`git revert --no-edit f4a95`重做提交`dev2`（`--no-edit`表示不修改新增提交的注释）：

![image-20200414153456451](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301106538.image)

重做后，多了一次提交，并且`test.txt`文件中删除了`dev2`这一行内容。此时，可以通过：

```
git revert --no-edit 582d127

```

重做上一次重做操作，以此达到取消上一次重做操作的目的：

![image-20200414153724455](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301106590.image)

如上图所示，虽然多出了一次提交，但是`test.txt`文件中被删除的`dev2`内容被恢复了，这样就撤销了`revert`操作。

### Ⅲ.`git checkout`

#### 1.`git checkout commit_id`

使用`checkout`可以进行版本回退，如直接使用：

```
git checkout cb214 

```

回退到提交`3rd`，此时会出现如下提示：

![image-20200311111540863](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301106736.image)

注意到，切换后`HEAD`指向的不再是`master`分支，而是`cb214...`即第三次提交，查看历史提交记录：

![image-20200311111719389](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301106205.image)

可看到只有`3`次提交，什么意思呢？如下图所示：

![image-20200412001646768](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301106569.image)

![image-20200311112656834](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301107947.image)

通过`git checkout`让`HEAD`指针指向了第`3`次提交，可以将它想象为一个新的分支。但是却没有实际创建分支，即此时`head`指向的由提交`1~3`组成的`commit`对象链条处于游离状态；

接着，在`HEAD`还指向游离的提交节点`3`的基础上对文件做出新的修改：

![image-20200311113237150](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301107564.image)

*   此时如果我们切换回`master`分支，会出现下列错误

![image-20200311113209483](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301107178.image)

提示显示：如果没有保存就从游离的提交上切换到`master`分支，这一修改就会被`checkout`命令覆盖。我们可以在切换前进行一次提交操作：

![image-20200311113625297](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301107915.image)

此时的状态为：

![image-20200412002213790](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301107738.image)

*   在游离的`Commit`对象链中进行了一次提交之后，再次通过：`git checkout master`切换到`master`分支：

![image-20200311114055018](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301107243.image)

提示大意为：如果没有任何分支指向刚才在游离的`Commit`对象链中进行的提交，那么该提交就会被忽略。此时的状态如下图所示：

![image-20200412002655921](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301108718.image)

如果想要创建一个分支保存（指向）这条游离的`Commit`对象链，现在就是很好的时机。根据上述提示的命令：

```
git branch mycommit  c4d5cc3

```

创建指向`commit_id`为`c4d5cc3`的提交（即上述的提交节点`5`）的分支`mycommit`：

![image-20200311115117279](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301108392.image)

由此游离的`commit`对象链得以被新分支所指向，并得到了保存，此时的状态如下图所示：

![image-20200412004042471](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301108526.image)

> **总结：**
> 
> *   通过`checkout`进行版本回退会造成游离的提交对象链，需要额外创建一个分支进行保存；
> *   因此，使用`checkout`进行版本回退的思路为，先切换到想要回退的提交版本，再删除进行版本回退的分支`dev`。最后，创建一个新的`dev`分支指向游离的提交对象链，完成分支`dev`的版本回退，简称"偷天换日"；
> *   只要有分支指向，提交就不会被丢弃。

### Ⅳ.`revert`与`reset`的选择

由于`checkout`会造成游离的提交对象链，所以，一般不使用`checkout`而是使用`reset`和`revert`进行版本回退：

*   `revert`通过创建一个新提交的方式来撤销某次操作，该操作之前和之后的提交记录都会被保留，并且会将该撤销操作作为最新的提交；
*   `reset`是通过改变`HEAD`和分支指针指向的方式，进行版本回退，该操作之后的提交记录不会被保留，并且不会创建新的提交；

在个人开发上，建议使用`reset`；但是在团队开发中建议使用`revert`，特别是公共的分支（比如`master`)，这样能够完整保留提交历史，方便回溯。

### Ⅴ.回退方法汇总

版本回退主要有**三大方式**：`reset`、`revert`和`checkout`，各方式的比较如下：

| 方法 | 效果 | 向前回退 | 向后回退 | 同步修改`HEAD`与分支指向 |
| --- | --- | --- | --- | --- |
| `git reset --hard HEAD^` | 往前回退`1`次提交 | 能 | 否 | 是 |
| `git reset --hard HEAD^^` | 往前回退`2`次提交 | 能 | 否 | 是 |
| `git reset --hard HEAD~n` | 往前回退`n`次提交 | 能 | 否 | 是 |
| `git reset --hard <commit_id>` | 回退到指定`commit id`的提交 | 能 | 能 | 是 |
| `git revert HEAD` | 重做最新一次提交 | 能 | 否 | 是 |
| `git revert HEAD^` | 重做倒数第二次提交 | 能 | 否 | 是 |
| `git revert HEAD^^` | 重做倒数第三次提交 | 能 | 否 | 是 |
| `git revert HEAD~n` | 重做倒数第`n+1`次提交 | 能 | 否 | 是 |
| `git revert commit_id` | 重做指定`commit_id`的提交 | 能 | 能 | 是 |
| `git checkout commit_id` | 回退到指定`commit id`的提交 | 能 | 能 | 否 |

从上表可知，只有下列三种方式可以自由地向前向后回退：

```
git reset --hard commit_id
git revert commit_id
git checkout commit_id

```

但是，使用`checkout`进行回退会出现游离的提交，需要创建一个新分支进行保存，所以不常用。

二、`git stash`
-------------

#### 1.`git stash`的作用

`git stash`指令的作用为：对没有提交到版本库的，位于工作区或暂存区中游离的修改进行保存，在需要时可进行恢复。具体应用场景如下：

在`master`分支进行两次提交：`1st`和`2nd`，随后创建并切换到`dev`分支。在`dev`分支上进行一次提交（`dev1`），此时两分支的状态为：

![image-20200412235844426](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301108081.image)

随后在`dev`分支上给文件`test.txt`添加一行`dev2`，但是不提交到暂存区，直接切换到`master`分支，会出现如下错误：

![image-20200413001632846](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301108229.image)

图中显示的错误大意为：在`dev`分支上的修改会被`checkout`操作覆盖。下面我们来看看，将`dev`分支上的这一修改操作添加到暂存区后，再切换分支，是否还会出现同样的问题：

![image-20200413001752227](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301108839.image)

可见还是会出现该错误，这初步验证了位于工作区和暂存区中的修改都会被`checkout`操作覆盖的结论。原因如下图所示：

![image-20200413001917190](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301109688.image)

虽然在`dev`分支上修改了文件，但是没有将这一修改操作进行提交。这样就不会产生提交节点，就如上图所示，修改`dev2`是游离的，在切换分支的时候会被丢弃。

这种情况在日常开发中很常见，当在`develop`分支上开发新功能的时候，`master`分支出现紧急情况需要切换回去进行修复。但是，当前分支的新功能还没开发完全，贸然切换分支，原来开发的内容就会因被覆盖而丢失，怎么办呢？

有人可能会说进行一次`commit`不就可以了吗？确实可以。但是，这样不符合提交的代码就是正确代码的原则。更好的解决方法为使用`git stash`，如下图所示：

![image-20200413002115302](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301109677.image)

可见`git stash`可以将当前`dev`分支上，位于在工作区或暂存区中的修改，在未提交的情况下进行了保存；并且将分支回退到修改前的状态，保存过后，就可以很顺畅地切换回`master`分支了。

> 图中的`WIP`（`working in progress`）表示的是正在进行的工作；

当我们在`master`分支上完成了工作，再次切换回`dev`分支时，查看`test.txt`文件：

![image-20200413002256321](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301109078.image)

发现切换分支前所做的修改`dev2`消失了，这是为什么呢？

*   其实，上面通过`git stash`将`dev`分支上工作区或暂存区中的修改，提交到了`stash`区域进行保存，并将`dev`分支回退到修改前的状态。如下图所示：
    
    ![image-20200413003349365](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301109676.image)
    
*   切换到`master`分支时`test`分支上的修改依旧会被覆盖。所以，再次回到`dev`分支时需要从`stash`区域中恢复切换分支前保存的修改；
    

怎样恢复通过`git stash`保存到`stash`中的修改呢？可以通过：

```
git stash list

```

查看该分支上被`stash`保存的修改：

![image-20200413224408623](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301109221.image)

继续给`test.txt`文件添加内容：`dev3`，并通过以下指令保存修改的同时添加注释：

```
git stash save '注释'

```

![image-20200413225024618](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301109732.image)

*   首先，通过上述命令可以修改`stash`中存储修改的备注信息；
*   其次，虽然在`test`分支上进行了两次修改，但是使用`git stash`保存修改后，文件`test.txt`并没有实际被修改；

#### 2.恢复`stash`存储的修改

方法有很多，主要有以下三种：

##### `git stash pop`

![image-20200413225140030](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301109359.image)

如图所示，通过上述命令将`stash`中存储的最新一次修改恢复了。相信你已经发现了，`stash`与**栈**非常类似：先保存的修改，排在最后，序号最大；后保存的修改，排在最前，序号最小；

恢复了最新一次修改后，再次查看`stash`：

![image-20200413225221071](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301110445.image)

可以看到存储的修改只剩下一条了，由此可推断出`git stash pop`作用为：

*   \*\*第一：\*\*恢复`stash`中存储的最新一次修改；
*   \*\*第二：\*\*将该修改从`stash`中删除；

##### `git stash apply`

![image-20200413225457480](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301110409.image)

如上图所示，使用该指令时发生了合并冲突。这是因为，`stash`中保存的每一次修改代表的都是一个版本。

![image-20200413231349820](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301110310.image)

*   如上图所示，在`test`分支上，进行第一次修改后，通过`git stash`将该修改作为修改`0`保存到`stash`中，此时分支中的文件并没有发生改变；
*   进行第二次修改后，通过`git stash`将修改作为修改`1`保存到`stash`中，分支中的文件依旧没有发生改变；此时的`stash`中相当于保存着同一分支上两个修改后的版本；
*   此时通过\*\*`git stash pop`**取出修改`0`，与`test`分支进行合并；再通过**`git stash pop`\*\*取出修改`1`，再次与`test`分支进行合并，两个版本合并自然会产生冲突。

手动解决冲突后，要进行一次提交才算完成了手动合并；随后查看`stash`：

![image-20200413230750201](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301110378.image)

修改`0`仍然存在，说明\*\*`git stash apply`\*\*的作用为取出`stash`中最新（前面）的修改并与分支进行合并。但是，`stash`中存储的该修改并不会被删除；

##### `git stash apply stash@{n}`

这是最常用的方法，作用为从`stash`中恢复特定的修改，并且不删除`stash`中的该修改。

将`test.txt`的两次修改通过`git stash`存储到`stash`中，如下图所示：

![image-20200413232024080](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301110739.image)

通过`git stash apply stash@{1}`恢复`stash`中存储的修改`1`：

![image-20200413232309330](https://cdn.jsdelivr.net/gh/wangyuan0108/img/note/202212301110148.image)

如上图所示，成功地恢复了`stash`中的修改`1`，并且`stash`中的修改`1`并没有被删除；

**总结：**

*   `git stash pop`：恢复并删除`stash`中存储的最新修改；
*   `git stash apply`：恢复但不删除`stash`中存储的最新修改；
*   `git stash apply stash@{0}`：恢复但不删除`stash`中存储的特定提交；
