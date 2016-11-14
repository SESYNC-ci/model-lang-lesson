---
---

## Loops and conditionals

A `for` loop takes a list and executes a block of code once for each
element of the list.


~~~python
>>> for i in range(1, 5):
...     j = i * 2
...     print(j)
...
2
4
6
8

~~~
{:.term}



===

The `range(i, j)` function creates a list of integers from `i` to `j - 1`; just
like in the case of list slices, the upper bound is excluded. 

Note the pattern of the block above: the `for` statement is followed by a colon,
each line in the following block is indented at the same level, and there is no
delimiter or statement indicating the end of the block. Compared with other
programming languages where code indentation only serves to enhance readability, 
code blocks in Python are defined by changes in indentation. 

===

A `for` loop can be used to iterate over the elements of any list. In the
following example, we create a contact list (as a list of dictionaries), then
perform a loop over all contacts. Within the loop, we use a conditional 
statement (`if`) to check if the name is 'Ann'. If so, we print the phone 
number; if not (`else` block), we print the name.


~~~python
>>> contacts = [
...     {'name': 'Ann', 'phone': '555-111-2222'},
...     {'name': 'Bob', 'phone': '555-333-4444'},
...     ]
...
...
>>> for c in contacts:
...     if c['name'] == 'Ann':
...         print(c['phone'])
...     else:
...         print(c['name'])
...
555-111-2222
Bob

~~~
{:.term}



===

**Exercise**: Write a loop that prints all even numbers between 1 and 9. 
Note:  if `i` is even, `i % 2 == 0`, where `%` is the modulo (or division
remainder) operator.