# A Shared Memory Based IPC Mechanism in Rust

## Composition

1. `fdpass-rs`: This is an older crate found [here](https://github.com/stemjail/fdpass-rs). However, the code only needed slight brushing up to work with latest Rust versions. Async versions of the functions have been added in case anyone wants to use them.
2. `ipc-queue`: This is the underlying data structure that holds pointers to raw, anonymous files mapped to the virtual memory of the process. It uses a (non-blocking) Unix socket to send control messages which basically tell the processes where the pointers are. This crate can be safely used to provide *one-way connection only*. Currently, it will *not throw an error* if the same queue is used to communicate in both directions (and might be possible with careful programming) but it is more likely to corrupt the data. **This queue needs to number of elements and size of each element.**
3. `memenpsf`: This crate has two structures that hierarchically wraps around the `ipc-queue` to provide safe, bidirectional communication and an easy to use API. This crate exports functions like `recv`, `recv_vectored` and `xmit` to enable users to start using the IPC without having to figure out all the internal structures.
4. Examples: `ipc-server` and `ipc-client` are examples of how this shared memory IPC can be used to provide connectivity between two unrelated processes.

## Advantages

- The processes don't need to be in parent-child or sibling relationship. This crate allows any two processes to communicate with each other.
- With certain changes to the code, these crates can establish bidirectional communication network between any number of processes.

## Cons

- Despite a reasonably user-friendly API, some care still needs to be taken while programming with this. For example, element sizes and maximum number of elements have to be mentioned.
  - `Interface::<[u8; 2]>::run(...)` explicitly mentions that we will store 2 element u8 arrays in the queue.
  - `Interface::<&[u8]>::run(name, cap, typ, stream, recvr, sender)` can some times result in a segmentation fault.

## Current Issues

- Both client and server run an infinite loop sending and receving data over and over again to make sure that both sides receive data properly.
- Furthermore, the server side runs this infinite loop within the match stream loop and as a result gets stuck with a single client.

Both these issues might be resolved by refactoring the code.
