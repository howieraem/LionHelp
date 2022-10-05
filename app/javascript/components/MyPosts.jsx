import React from "react";
import {Modal, ModalHeader, ModalBody, Button, Row, FormGroup, Input} from "reactstrap";
import { Link } from "react-router-dom";

class MyPosts extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            posts: [],
            isCommentOpen: false,
            comment: "",
            curPost: null
        }
        this.handlePostDelete = this.handlePostDelete.bind(this);
        this.handleCommentChange = this.handleCommentChange.bind(this);
        this.submitComment = this.submitComment.bind(this);
    }

    componentDidMount() {
        // if(localStorage.getItem('token')!=null){
        if (this.props.login) {
            const url = this.props.cur ? "/api/v1/posts/cur_posts" : "/api/v1/posts/pre_posts";
            fetch(url)
                .then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    throw new Error("Network response was not ok.");
                })
                .then(response => this.setState({ posts: response }))
                .catch(() => this.props.history.push("/"));
        } else {
            alert("Please login or sign up first!");
        }
    }

    handlePostDelete(postID) {
        const url = `/api/v1/posts/destroy/${postID}`;
        fetch(url, {
            method: "DELETE",
            headers: {
                "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
            }})
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                    return;
                }
            throw new Error("Network response was not ok. Failed to delete post!");
        })
    }

    completeRequest(post) {
        if (this.props.login) {
            const url = `/api/v1/posts/complete2?id=${post.id}`;
            fetch(url)
                .then(response => {
                    if (response.ok) {
                        this.setState({
                            isCommentOpen: true,
                            curPost: post
                        })
                    } else {
                        // failed to mark complete, refresh page
                        this.props.history.push("/pre_posts")
                    }
                });
        } else {
            alert("Please login or sign up first!");
        }
    }

    handleCommentChange(event) {
        this.setState({
            comment: event.target.value
        });
    }

    submitComment(ev) {
        ev.preventDefault();
        if (this.props.login) {
            const url = "/api/v1/posts/comment";
            const dataBody = {
                postID: this.state.curPost.id,
                commentee: this.state.curPost.helperEmail,
                commenter: this.state.curPost.email,
                content: this.state.comment
            }
            fetch(url, {
                method: "POST",
                headers: {
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(dataBody)
            })
                .then(response => {
                    this.setState({
                        curPost: null,
                        isCommentOpen: false,
                        comment: ""
                    })
                    this.props.history.push("/pre_posts")
                });  // refresh after comment regardless of failure
        } else {
            alert("Please login or sign up first!");
        }
    }

    render() {
        const posts = this.state.posts.map((post) => {
            return (
                <div key={post.id} className="col-12 col-md-8 offset-md-1" style={{
                    marginBottom: "30px",
                    borderStyle: "outset",
                    borderRadius: "10px",
                    borderWidth: "1px",
                    borderColor: "rgba(224,224,224,0.3)"
                }}>
                    <div className="col-12 col-md-6 offset-md-3" style={{marginTop: "40px"}}>
                        <p><strong>Title:</strong> {post.title}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Location:</strong> {post.location}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Room:</strong> {post.room}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Start Time:</strong> {post.startTime}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>End Time:</strong> {post.endTime}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Credit:</strong> {post.credit}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Request:</strong> {post.taskDetails}</p>
                    </div>
                    <div className="col-12 col-md-6 offset-md-3">
                        <p><strong>Helper Email:</strong> { post.helperEmail === 'null' ? "(No one taken yet)" : post.helperEmail }</p>
                    </div>
                    <div className="row">
                        {this.props.cur && (
                            <center>
                                <strong>
                                    <Button
                                        color="primary"
                                        onClick={() => this.props.history.push(`/edit/${post.id}`)}
                                        style={{
                                            color: '#FFF',
                                            minWidth: 100,
                                            maxWidth: 100,
                                            margin: 10
                                        }}
                                    >
                                        Edit
                                    </Button>
                                    <Button
                                        color="danger"
                                        onClick={() => this.handlePostDelete(post.id)}
                                        style={{
                                            color: '#FFF',
                                            minWidth: 100,
                                            maxWidth: 100,
                                            margin: 10
                                        }}
                                    >
                                        Delete
                                    </Button>
                                </strong>
                            </center>
                        )}
                        {!this.props.cur && !post.requesterComplete && (
                            <center>
                                <strong>
                                    <Button
                                        color="success"
                                        onClick={() => this.completeRequest(post)}
                                        style={{
                                            color: '#FFF',
                                            minWidth: 100,
                                            maxWidth: 100,
                                            margin: 10
                                        }}
                                    >
                                        Complete
                                    </Button>
                                </strong>
                            </center>
                        )}
                    </div>
                </div>
            );
        });

        return (
            <>
                <div className="container">
                    <div className="col-12" style={{marginTop: "100px"}}>
                        <div className="row">
                            <div className="col-12 col-md-6">
                                <h5 style={{fontFamily: "Arial Black", display: "inline"}}>
                                    {this.props.cur ? "Current Requests" : "Requests Completed"}
                                </h5>
                            </div>
                        </div>
                        <hr className="separation"/>
                    </div>
                    <div className="col-12" style={{marginTop: "50px"}}>
                        <div className="row">
                            {posts}
                        </div>
                    </div>
                </div>
                <Modal isOpen={this.state.isCommentOpen}>
                    <ModalHeader>Comment about the Helper</ModalHeader>
                    <ModalBody style={{marginTop:"20px"}}>
                        <FormGroup>
                            <Input
                                type="text"
                                className="comment-input"
                                name="helperComment"
                                placeholder="Please input your comment about the helper"
                                onChange={this.handleCommentChange}
                            />
                        </FormGroup>
                        <Button
                            type="submit"
                            className="searchButton"
                            style={{backgroundColor:"white", border:"none"}}
                            onClick={this.submitComment}
                        >
                            <b style={{color:"rgb(2, 33, 105)"}}><center>Submit Comment</center></b>
                        </Button>
                    </ModalBody>
                </Modal>
            </>
        );
    }
}

export default MyPosts;