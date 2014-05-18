#include <stdio.h>
#include <malloc.h>

typedef struct treeNode
{
	union { int val1;
			char * name2; }attr1;
	union { int val2;
			char * name2; }attr2;
} TreeNode;

main()
{
	printf("haha\n");
 TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
 t->attr1.val1 = 10;
 t->attr2.name2 = "hahaha";

 printf("%d\n",t->attr1.val1);
 printf("%s\n",t->attr2.name2);
 printf("%d\n",sizeof(t->attr2));

}
